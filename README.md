# Beaker::TestmodeSwitcher

When testing modules and other Puppet software with beaker, you need to choose up-front whether to drive the tests using `puppet apply` directly on an agent VM; or using a master/agent setup; or by running the code directly on your workstation. While choosing the apply approach is tempting due to the reduced resource usage, most Puppet deployments are running master/agent setups, and those have subtle differences to `puppet apply` that might trip up your code. To solve this dilemma, use this gem to choose the test mode at runtime!

Beaker::TestmodeSwitcher supports running tests in master/agent mode, or using `puppet apply` on an agent host, or locally without any setup.

## Usage

Set up your module for beaker testing as usual. Additionally add

```ruby
gem 'beaker-testmode_switcher'
```

to the `:system_tests` group in your module's Gemfile. Add

```ruby
require 'beaker/testmode_switcher/dsl'
```

to your `spec/spec_helper_acceptance.rb` to enable the DSL extensions. Instead of using `#apply_manifest_on` or `#run_agent_on` you can now use `#execute_manifest_on` and - depending on the test mode - will upload and execute the manifest on the right node(s).

The `BEAKER_TESTMODE` environment variable determines how the tests are run:

* `local`: No VMs are provisioned and tests are run using the context of your test runner. This mode is great for development, but may require running the tests as root and may cause unwanted system changes to your workstation.
* `apply`: VMs are provisioned as normal (determined by the nodeset) and tests of Puppet manifests are run with `puppet apply` on the specified node. This mode only requires a single VM and is great for running the tests in an isolated environment. When the nodeset has more than one node, exactly one has to have the 'default' role assigned. This will be the node to execute the manifests.
* `agent`: VMs are provisioned as normal (determined by the nodeset). When running tests with Puppet manifests, the manifest is uploaded to the master and a `puppet agent` run is kicked off on the specified node. This mode requires multiple VMs and a more involved provisioning step, but the tests run in a more production-like environment to ensure highest fidelity of the test results. The nodeset needs to contain one node with the 'master' role assigned. This will be the node to receive the manifest. When the nodeset has more than one node, exactly one has to have the 'default' role assigned. This will be the node to execute the puppet agent.

## Acceptance tests

Beaker and Beaker-rspec frameworks are supported. The environment variable `TEST_FRAMEWORK` MUST be set before the gem/bundle install.

The `TEST_FRAMEWORK` environment variable determines the gem support for the test run:
* `beaker` Beaker only support.
* `beaker-rspec` Beaker-rspec support.

The acceptance tests will immediately fail if the environment variable is not set.

To run the tests `bundle exec rake`

## Reference

This experimental version supports only a minimal set of functionality from the beaker DSL:

* `create_remote_file_ex(file_path, file_content, opts = {})`: Creates a file at `file_path` with the content specified in `file_content` on the default node. `opts` can have the keys `:mode`, `:user`, and `:group` to specify the permissions, owner, and group respectively.

* `execute_manifest_on(hosts, manifest, opts = {})`: Execute the manifest on all nodes. This will only work when `BEAKER_TESTMODE`, is set to `agent` and it will run a `puppet agent` run.
  
  `opts` keys:
  * `:debug`, `:trace`, `:noop`: set to true to enable the puppet option of the same name.
  * `:dry_run`: set to true to skip executing the actual command.
  * `:environment`: pass environment variables for the command as a hash.
  * `:catch_failures` enables detailed exit codes and causes a test failure if the puppet run indicates there was a failure during its execution.
  * `:catch_changes` enables detailed exit codes and causes a test failure if the puppet run indicates that there were changes or failures during its execution.
  * `:expect_changes` enables detailed exit codes and causes a test failure if the puppet run indicates that there were no resource changes during its execution.
  * `:expect_failures` enables detailed exit codes and causes a test failure if the puppet run indicates there were no failure during its execution.

* `execute_manifest(manifest, opts = {})`: Execute the manifest on the default node. Depending on the `BEAKER_TESTMODE` environment variable, this may use `puppet agent` or `puppet apply`. Calls execute_manifest_on when `BEAKER_TESTMODE`=`agent`
  
  `opts` keys:
  * `:debug`, `:trace`, `:noop`: set to true to enable the puppet option of the same name.
  * `:dry_run`: set to true to skip executing the actual command.
  * `:environment`: pass environment variables for the command as a hash.
  * `:catch_failures` enables detailed exit codes and causes a test failure if the puppet run indicates there was a failure during its execution.
  * `:catch_changes` enables detailed exit codes and causes a test failure if the puppet run indicates that there were changes or failures during its execution.
  * `:expect_changes` enables detailed exit codes and causes a test failure if the puppet run indicates that there were no resource changes during its execution.
  * `:expect_failures` enables detailed exit codes and causes a test failure if the puppet run indicates there were no failure during its execution.

* `resource(type, name, opts = {})`: Runs `puppet resource` with the specified `type` and `name` arguments.
  `opts` keys:
  * `:debug`, `:trace`, `:noop`: set to true to enable the puppet option of the same name.
  * `:values`: pass a hash of key/value pairs which is passed on the commandline to `puppet resource` to influence the specified resource.
  * `:dry_run`: set to true to skip executing the actual command.
  * `:environment`: pass environment variables for the command as a hash.

* `scp_to_ex(from, to)`: Copies the file `from` to the location `to` on all nodes.

* `shell_ex(cmd, opts = {})`: Execute a shell command on the default node.
  `opts` keys:
  * `:dry_run`: set to true to skip executing the actual command.
  * `:environment`: pass environment variables for the command as a hash.
  * `:chdir`: the directory in which to run the command.
  * See `Process.spawn()`'s `options` argument for more attributes.

Other helpful methods:

* `Beaker::TestmodeSwitcher.mode`: Returns the currently configured test mode.
* `Beaker::TestmodeSwitcher.runner`: Returns the currently configured runner.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

### Releasing

To release a new version, update the version number in `lib/beaker/testmode_switcher/version.rb`, update CHANGELOG.md, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
