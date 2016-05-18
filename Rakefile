require "bundler/gem_tasks"

def beaker_command
  cmd_parts = []
  cmd_parts << "beaker"
  cmd_parts << "--debug"
  cmd_parts << "--test spec/test"
  cmd_parts << "--load-path lib"
  cmd_parts.flatten.join(" ")
end

if ENV['TEST_FRAMEWORK'] && ENV['TEST_FRAMEWORK'] == 'beaker'
  task spec: [:beaker]
else
  task spec: [:rspec]
end

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
  raise "LoadError for default rake target. [#{error}] "
end
