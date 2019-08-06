require 'beaker/testmode_switcher'

module Beaker
  module TestmodeSwitcher
    # include this module into your namespace to access the DSL parts of TestmodeSwitcher
    module DSL
      # pass through methods to the runner
      %i[create_remote_file_ex scp_to_ex shell_ex resource execute_manifest execute_manifest_on fact].each do |name|
        define_method(name) do |*args|
          # `hosts`, and `logger` are beaker DSL accessors in the global scope. Do not fail here, if they're not available.
          my_hosts = (hosts if respond_to? :hosts)
          my_logger = (logger if respond_to? :logger)
          Beaker::TestmodeSwitcher.runner(my_hosts, my_logger).send(name, *args)
        end
      end
    end
  end
end

include Beaker::TestmodeSwitcher::DSL # rubocop:disable Style/MixinUsage  This usage is expected
