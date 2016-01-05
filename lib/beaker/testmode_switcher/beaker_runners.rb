require 'beaker'
require 'shellwords'
require 'open3'

module Beaker
  module TestmodeSwitcher
    # Re-used functionality for all beaker runners
    class BeakerRunnerBase
      include Beaker::DSL

      # create a remote file (using puppet apply) on the default host
      def create_remote_file_ex(file_path, file_content, options = {})
        mode = options[:mode] || '0644'
        user = options[:user] || 'root'
        group = options[:group] || 'root'
        file_content.gsub!(/\\/, '\\')
        file_content.gsub!(/'/, "\\'")
        file_content.gsub!(/\n/, '\\n')
        apply_manifest_on default, "file { '#{file_path}': ensure => present, content => '#{file_content}', mode => '#{mode}', user => '#{user}', group => '#{group}' }", catch_failures: true
      end

      # execute a puppet resource command on the default host
      def resource(type, name, opts = {})
        cmd = ["resource"]
        cmd << "--debug" if opts[:debug]
        cmd << "--noop" if opts[:noop]
        cmd << "--trace" if opts[:trace]
        cmd << type
        cmd << name

        if opts[:values]
          opts[:values].each do |k, v|
            cmd << "#{k}=#{v}"
          end
        end

        on(default,
           puppet(*cmd),
           dry_run: opts[:dry_run],
           environment: opts[:environment] || {},
           acceptable_exit_codes: (0...256)
          )
      end

      # copy a file using beaker's scp_to to all hosts
      def scp_to_ex(from, to)
        hosts.each do |host|
          scp_to host, from, to
        end
      end

      # execute an arbitrary command on the default host
      def shell_ex(cmd)
        shell(cmd)
      end
    end

    # All functionality specific to running in 'agent' mode
    class BeakerAgentRunner < BeakerRunnerBase
      require 'master_manipulator'
      include MasterManipulator::Site

      # upload the manifest to the master and inject it into the site.pp
      # then run a puppet agent on the default host
      def execute_manifest(manifest, opts = {})
        environment_base_path = on(master, puppet('config', 'print', 'environmentpath')).stdout.rstrip
        prod_env_site_pp_path = File.join(environment_base_path, 'production', 'manifests', 'site.pp')
        site_pp = create_site_pp(master, manifest: manifest)
        inject_site_pp(master, prod_env_site_pp_path, site_pp)

        cmd = ['agent', '--test', '--environment production']
        cmd << "--debug" if opts[:debug]
        cmd << "--noop" if opts[:noop]
        cmd << "--trace" if opts[:trace]

        # acceptable_exit_codes are passed because we want detailed-exit-codes but want to
        # make our own assertions about the responses
        on(default,
           puppet(*cmd),
           dry_run: opts[:dry_run],
           environment: opts[:environment] || {},
           acceptable_exit_codes: (0...256)
          )
      end
    end

    # All functionality specific to running in 'apply' mode
    class BeakerApplyRunner < BeakerRunnerBase
      # execute the manifest by running puppet apply on the default node
      def execute_manifest(manifest, opts = {})
        # acceptable_exit_codes and expect_changes are passed because we want detailed-exit-codes but want to
        # make our own assertions about the responses
        apply_manifest(
          manifest,
          expect_changes: true,
          debug: opts[:debug],
          dry_run: opts[:dry_run],
          environment: opts[:environment] || {},
          noop: opts[:noop],
          trace: opts[:trace],
          acceptable_exit_codes: (0...256)
        )
      end
    end
  end
end
