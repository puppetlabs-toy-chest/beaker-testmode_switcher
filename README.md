# Beaker::TestmodeSwitcher

When testing modules with beaker, you need to choose up-front whether to drive the tests using `puppet apply` or a master/agent setup. While choosing the apply approach is tempting due to the reduced resource usage, everyone is running master/agent setups, and those have subtle differences to `puppet apply` that might trip up your code. To solve this dilemma, use this gem to choose the test mode at runtime!

Beaker::TestmodeSwitcher supports running tests in master/agent mode, or using `puppet apply` or locally without any setup.

## Installation

Add this line to your application's Gemfile:

## Usage

Set up you module for beaker testing as usual. Additionally add

```ruby
gem 'beaker-testmode_switcher'
```

to the `:system_tests` group in your module's Gemfile. Instead of using `#apply_manifest_on` or `#run_agent_on` you can now use `#execute_manifest_on` and - depending on the test mode - will upload and execute the manifest on the right node(s).

The `BEAKER_TESTMODE` environment variable determines how the tests are run:

* `local`: No VMs are provisioned and tests are run with `puppet apply` using the context of your test runner. This mode uses the least resources and is great for development, but may require running the tests as root and could trash the system.
* `apply`: VMs are provisioned as normal (determined by the nodeset) and tests are run with `puppet apply` on the specified node. This mode only requires a single VM and is great for running the tests in an isolated environment.
* `agent`: VMs are provisioned as normal (determined by the nodeset). When running tests, the manifest is uploaded to the master and a full `puppet agent` run is kicked off on the specified node. This mode requires multiple VMs and a more involved provisioning step, but the tests run in a very production-like environment to ensure highest fidelity of the test results.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/puppetlabs/beaker-testmode_switcher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
