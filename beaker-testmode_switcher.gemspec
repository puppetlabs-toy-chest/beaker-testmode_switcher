# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beaker/testmode_switcher/version'

Gem::Specification.new do |spec|
  spec.name          = "beaker-testmode_switcher"
  spec.version       = Beaker::TestmodeSwitcher::VERSION
  spec.authors       = ["Puppet Labs", "David Schmitt", "Gareth Rushgrove", "Greg Hardy"]
  spec.email         = ["modules-team@puppetlabs.com"]

  spec.summary       = "Let's you run your puppet module tests in master/agent, apply or local mode."
  spec.homepage      = "https://github.com/puppetlabs/beaker-testmode_switcher"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "beaker"
  spec.add_dependency "master_manipulator"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
