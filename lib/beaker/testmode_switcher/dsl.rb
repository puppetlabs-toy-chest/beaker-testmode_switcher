require 'beaker/testmode_switcher'

module Beaker
  module TestmodeSwitcher
    # include this module into your namespace to access the DSL parts of TestmodeSwitcher
    module DSL
      # pass through methods to the runner
      [:create_remote_file_ex, :scp_to_ex, :shell_ex, :resource, :execute_manifest, :execute_manifest_on].each do |name|
        define_method(name) do |*args|
          Beaker::TestmodeSwitcher.runner(hosts, logger).send(name, *args)
        end
      end
    end
  end
end

include Beaker::TestmodeSwitcher::DSL
