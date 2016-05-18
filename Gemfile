source 'https://rubygems.org'

gemspec

group :test do
  gem 'rubocop', require: false
end

group :development do
  gem 'guard'
  gem 'guard-rake'
  gem 'guard-rspec' unless ENV['TEST_FRAMEWORK'] == 'beaker'
  gem 'pry-coolline'
end
