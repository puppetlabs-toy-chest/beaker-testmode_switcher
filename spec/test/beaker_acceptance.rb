require 'beaker/testmode_switcher/dsl'
require 'beaker/testmode_switcher/version'

def test_env_verified
  ['beaker-rspec', 'rspec', 'rspec-core'].each do |gemname|
    begin
      require gemname.to_s
      fail_test "The #{gemname} gem shall not be loaded for a beaker test"
    rescue LoadError
      puts "Verified that gem #{gemname} is not loaded"
    end
  end
end

test_name 'Test TestmodeSwitcher with beaker'

test_env_verified
fail_test "Test mode switcher has no version" unless Beaker::TestmodeSwitcher::VERSION
fail_test "Test mode switcher has no version" unless Beaker::TestmodeSwitcher.testmode
