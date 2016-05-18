require "bundler/gem_tasks"
require 'pry'

def beaker_command
  cmd_parts = []
  cmd_parts << "beaker"
  cmd_parts << "--debug"
  cmd_parts << "--test spec/test"
  cmd_parts << "--load-path lib"
  cmd_parts.flatten.join(" ")
end

abort "Acceptance will not start unless TEST_FRAMEWORK is set to [beaker|beaker-rspec]" unless ENV['TEST_FRAMEWORK'] =~ /beaker|beaker\-rspec/

task :spec => [:rspec] if ENV['TEST_FRAMEWORK'] == 'beaker-rspec'
task :spec => [:beaker] if ENV['TEST_FRAMEWORK'] == 'beaker'

task :rspec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
end

task :beaker do
  abort "Beaker test failed" unless system(beaker_command) == true
end

task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

begin
  task default: [:spec, :rubocop]
rescue LoadError => error
    fail "LoadError for default rake target. [#{error}] "
end
