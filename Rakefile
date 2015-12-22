require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:spec, :rubocop]
rescue LoadError # rubocop:disable Lint/HandleExceptions: rspec is optional
  # no rspec available
end
