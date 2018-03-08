# 2018-03-07 Version 0.4.0
### Summary
Adds the ability for execute_manifest_on to work in both agent and apply; improvements for create_remote_file_ex.

### Features
- Adds support for `execute_manifest_on` with `BEAKER_TESTMODE` set to `apply`

### BugFixes
- Fixes `create_remote_file_ex` so that opts accepts `:owner` instead of `:user`
- Improves content handling for `create_remote_file_ex`
- Minor fixes to option handling

# 2017-06-08 Version 0.3.0
### Summary
Adds a new parameter for shell_ex; and improvements for local test running.

### Features
- Implements `:chdir` option to `shell_ex`.

### BugFixes
- Makes `my_hosts` and `logger` global methods optional.

# 2017-06-02 Version 0.2.1
### Summary
Fixes for shell_ex when running on Windows; and a minor README update.

# 2017-03-03 Version 0.2.0
### Summary
Make use of catch_changes, catch_failures, expect_changes and expect_failures. This makes beaker-testmode_switcher easier to integrate into modules.

### Features
- Implement catch_changes, catch_failures, expect_changes and expect_failures in beaker_runners
- Fix docs issue where `execute_manifest` options were listed under `resource

# 2017-01-19 - Version 0.1.1
### Summary

This release adds a feature that provides control of specific nodes you would like to run an agent run on. Previously it was only possible to run on the default node.

### Features
- Add execute_manifest_on() function
- Add MAINTAINERS file
- Addressing Rubocop errors

# Version 0.1.0

Initial release.
