module Beaker
  module TestmodeSwitcher
    # A standard error to be raised by runner classes when an unexpected exit code is returned
    class UnacceptableExitCodeError < RuntimeError
    end

    # Contains functions used in both local runner and beaker runners
    class RunnerBase
      def get_acceptable_puppet_run_exit_codes(opts = {})
        # Ensure only one option given
        if [opts[:catch_changes], opts[:catch_failures], opts[:expect_failures], opts[:expect_changes]].compact.length > 1
          raise(ArgumentError,
                'Cannot specify more than one of `catch_failures`, \
                 `catch_changes`, `expect_failures`, or `expect_changes` \
                  for a single manifest')
        end

        # Return appropriate exit code
        return [0]        if opts[:catch_changes]
        return [0, 2]     if opts[:catch_failures]
        return [1, 4, 6]  if opts[:expect_failures]
        return [2]        if opts[:expect_changes]

        # If no option supplied, return all exit codes, as an array,
        # as acceptable so beaker returns a detailed output
        0...256
      end

      def handle_puppet_run_returned_exit_code(acceptable_exit_codes, returned_exit_code)
        return if acceptable_exit_codes.include?(returned_exit_code)
        acceptable_exit_codes_string = if acceptable_exit_codes.is_a?(Array)
                                         acceptable_exit_codes.join(', ')
                                       else
                                         acceptable_exit_codes_string.to_s
                                       end
        raise UnacceptableExitCodeError, "Unacceptable exit code returned: #{returned_exit_code}. Acceptable code(s): #{acceptable_exit_codes_string}"
      end
    end
  end
end
