require 'shellwords'
require 'open3'
require_relative 'runner_base'

module Beaker
  module TestmodeSwitcher
    # All functionality specific to running in 'local' mode
    class LocalRunner < RunnerBase
      # creates the file on the local machine and adjusts permissions
      # the opts hash allows the following keys: :mode, :user, :group
      def create_remote_file_ex(file_path, file_content, opts = {})
        File.open(file_path, 'w') { |file| file.write(file_content) }

        file_path_escaped = file_path.shellescape
        commands = []
        commands << "chmod #{opts[:mode].shellescape} #{file_path_escaped}" if opts[:mode]
        commands << "chown #{opts[:user].shellescape} #{file_path_escaped}" if opts[:user]
        commands << "chgrp #{opts[:group].shellescape} #{file_path_escaped}" if opts[:group]
        if commands.empty?
          success_result
        else
          use_local_shell(commands.join(' && '), {})
        end
      end

      # executes the supplied manifest using bundle and puppet apply
      # the opts hash works like the opts of [apply_manifest_on](http://www.rubydoc.info/github/puppetlabs/beaker/Beaker/DSL/Helpers/PuppetHelpers#apply_manifest_on-instance_method) in the Beaker DSL.
      # it accepts the following keys: :dry_run, :environment, :trace, :noop, and :debug
      def execute_manifest(manifest, opts = {})
        puts "Applied manifest [#{manifest}]" if ENV['DEBUG_MANIFEST']
        cmd = ["bundle exec puppet apply -e #{manifest.delete("\n").shellescape} --detailed-exitcodes --modulepath spec/fixtures/modules --libdir lib"]
        cmd << "--debug" if opts[:debug]
        cmd << "--noop" if opts[:noop]
        cmd << "--trace" if opts[:trace]

        res = use_local_shell(cmd.join(' '), opts)
        handle_puppet_run_returned_exit_code(get_acceptable_puppet_run_exit_codes(opts), res.exit_code)

        res
      end

      # build and execute complex puppet resource commands locally
      # the type argument is the name of the resource type
      # the name argument is the namevar of the resource
      # the opts hash works like the opts of [apply_manifest_on](http://www.rubydoc.info/github/puppetlabs/beaker/Beaker/DSL/Helpers/PuppetHelpers#apply_manifest_on-instance_method) in the Beaker DSL.
      # it accepts the following keys: :dry_run, :environment, :trace, :noop, and :debug
      # additionally opts[:values] can be set to a hash of resource values to pass on the command line
      def resource(type, name, opts = {})
        cmd = ["bundle exec puppet resource --modulepath spec/fixtures/modules --libdir lib"]
        cmd << "--debug" if opts[:debug]
        cmd << "--noop" if opts[:noop]
        cmd << "--trace" if opts[:trace]
        cmd << type.shellescape
        cmd << name.shellescape

        if opts[:values]
          opts[:values].each do |k, v|
            cmd << "#{k.shellescape}=#{v.shellescape}"
          end
        end

        # apply the command
        use_local_shell(cmd.join(' '), opts)
      end

      # copies the file locally
      def scp_to_ex(from, to)
        FileUtils.cp(from, to)
        success_result
      end

      # run a command through a local shell
      def shell_ex(cmd, opts = {})
        use_local_shell(cmd, opts)
      end

      private

      # build a Beaker::Result with a successful exit_code and no output
      def success_result
        result = Beaker::Result.new(:localhost, "")
        result.exit_code = 0
        result.finalize!
        result
      end

      # fork/exec a process and collect its output
      def use_local_shell(cmd, opts = {})
        if opts[:dry_run]
          puts "Would have run '#{cmd}'"
          success_result
        else
          capture_command(cmd, opts)
        end
      end

      # runs a command and captures its output in a Beaker::Result
      def capture_command(cmd, opts = {})
        blocks = {
          combined: [],
          out: [],
          err: []
        }
        exit_code = -1
        Open3.popen3(opts[:environment] || {}, cmd, opts) do |stdin, stdout, stderr, wait_thr|
          # TODO: pass through $stdin/terminal to subprocess to allow interaction - e.g. pry - the subprocess
          stdin.close_write

          files = [stdout, stderr]

          until files.all?(&:eof)
            ready = IO.select(files)
            next unless ready

            ready[0].each do |f|
              fileno = f.fileno
              begin
                begin
                  data = f.read_nonblock(1024)
                rescue IO::WaitReadable, Errno::EINTR
                  IO.select([f])
                  retry
                end
                until data.empty?
                  $stdout.write(data)

                  # create a combined block list for better output interleaving
                  blocks[:combined] << data

                  # store each stream separately for the Beaker::Result API
                  if fileno == stdout.fileno
                    blocks[:out] << data
                  else
                    blocks[:err] << data
                  end

                  # try reading more data
                  # when the command writes more than 1k at a time, this is required to drain buffers
                  # and avoid stdout/stderr interleaving
                  begin
                    data = f.read_nonblock(1024)
                  rescue IO::EAGAINWaitReadable
                    data = ""
                  rescue IO::WaitReadable, Errno::EINTR
                    IO.select([f])
                    retry
                  end
                end
              rescue EOFError, Errno::EBADF # rubocop:disable Lint/HandleExceptions: expected exception
                # pass on EOF
                # Also pass on Errno::EBADF (Bad File Descriptor) as it is thrown for Ruby 2.1.9 on Windows
              end
            end
          end

          exit_code = wait_thr.value.exitstatus
        end
        result = Beaker::Result.new(:localhost, cmd)
        result.stdout = blocks[:out].join
        result.stderr = blocks[:err].join
        result.output = blocks[:combined].join
        result.exit_code = exit_code
        result.finalize!
        result
      end
    end
  end
end
