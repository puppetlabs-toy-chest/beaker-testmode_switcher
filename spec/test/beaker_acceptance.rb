require 'beaker/testmode_switcher/dsl'
require 'beaker/testmode_switcher/version'

GEMLOCK_FILE = 'Gemfile.lock'

def test_env_verified
  fail_test "Gemspec.lock doesn't exist. Please bundle/gem install" unless File.exists?(GEMLOCK_FILE)
  fail_test "Rspec gems shall not be loaded for a beaker test" unless File.open(GEMLOCK_FILE).grep(/rspec/)
end

test_name 'Test TestmodeSwitcher with beaker'

test_env_verified
fail_test "Test mode switcher has no version" unless Beaker::TestmodeSwitcher::VERSION
fail_test "Test mode switcher has no version" unless Beaker::TestmodeSwitcher.testmode
