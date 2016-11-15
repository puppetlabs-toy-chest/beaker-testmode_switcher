source 'https://rubygems.org'

gemspec

group :test do
  gem 'rubocop', require: false
  gem 'bundler', '~> 1.9'
  gem 'rake', '~> 10.0'
  gem 'rspec', '~> 3' unless ENV['TEST_FRAMEWORK'] && ENV['TEST_FRAMEWORK'] == 'beaker' # Don't install rpsec if the module is in beaker only mode
  gem 'beaker', '2.42.0' if RUBY_VERSION <= '2.1.6'
  gem 'beaker' if RUBY_VERSION > '2.1.6'
end

group :development do
  gem 'pry'
  gem 'guard'
  gem 'guard-rake'
  gem 'guard-rspec' unless ENV['TEST_FRAMEWORK'] && ENV['TEST_FRAMEWORK'] == 'beaker'
  gem 'pry-coolline'
  gem 'listen', '= 3.0.7' # last version to support ruby 1.9; the proper fix would be to not install the development group in our internal CI
end
