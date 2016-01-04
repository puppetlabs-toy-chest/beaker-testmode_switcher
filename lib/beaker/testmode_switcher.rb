require 'beaker/testmode_switcher/beaker_runners'
require 'beaker/testmode_switcher/local_runner'

module Beaker
  # Contains the bulk of the code for switching the test mode.
  module TestmodeSwitcher
    # returns the current test mode
    def self.testmode
      mode = ENV['BEAKER_TESTMODE'] || 'apply'
      if %w(apply agent local).include? mode
        return mode.to_sym
      else
        fail ArgumentError, "Unknown BEAKER_TESTMODE supplied: '#{mode}'"
      end
    end

    # creates a test runner implementing the specified mode
    def self.create_runner(mode)
      case mode
      when :apply then
        BeakerApplyRunner.new
      when :agent then
        BeakerAgentRunner.new
      when :local
        LocalRunner.new
      end
    end

    # returns the current runner
    def self.runner
      @runner ||= create_runner(testmode)
    end
  end
end
