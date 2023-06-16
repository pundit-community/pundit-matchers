# Pundit Matchers

## 3.0.1 (2023-06-17)

- Allow to match dynamically defined actions

## 3.0.0 (2023-06-14)

- Drop RSpec < 3.12 and Pundit < 2 compatibility
- Eliminate ambiguity of negated matchers
- Add support for configuring user alias per policy
- Add support for nested attributes

### Breaking changes

#### Default User Alias

In order to allow to specify user alias on a policy basis, the `user_alias`
configuration has been renamed to `default_user_alias`. This will affect test
suites setting `config.user_alias`.

- Change `config.user_alias` to `config.default_user_alias`

#### Negated Matchers

The ambiguity of negated matchers has been eliminated, and this will affect
test suites using `not_to` matchers.

The following matchers will raise an error because of their ambiguity and
ask to switch to the opposite non-negated matcher:

- `not_to forbid_all_actions`
- `not_to forbid_only_actions`
- `not_to permit_all_actions`
- `not_to permit_only_actions`

The following matchers may fail, because there were ambiguous in the previous
implementation, and the application policies should be fixed:

- `not_to forbid_edit_and_update_actions`
- `not_to forbid_new_and_create_actions`
- `not_to forbid_actions` (with multiple actions)
- `not_to forbid_mass_assignment_of` (with multiple attributes)
- `not_to permit_actions` (with multiple actions)
- `not_to permit_edit_and_update_actions`
- `not_to permit_new_and_create_actions`
- `not_to permit_mass_assignment_of` (with multiple attributes)

## 2.3.0 (2023-05-23)

- Add compatibility spec to assist with transitioning to more consistent
  `not_to` behaviour in the next major version of this gem.
- Add more obvious warnings to the Readme regarding support for additional
  arguments to `permit_action` and `forbid_action` being removed.

## 2.2.0 (2023-05-11)

- Error message improvements. Replace "allow" with "permit" in error messages.
- Ensure that policy actions are returned in a deterministic order.
- Move `forbid_action` matcher outside of class scope.
- Improve code coverage in tests.
- Use modern default configuration for specs.
- Improvements to RuboCop config.
- Improvements to Readme examples.

## 2.1.0 (2023-04-28)

- Introduce `permit_only_actions` and `forbid_only_actions` matchers.
- Readme improvements, with `permit_only_actions` being the recommended matcher.
- Require multifactor authentication to publish gem.
- Enforce Ruby 3 in Gemfile (Ruby 2 support was dropped in the 2.0.0 release).
- Add rubocop-performance.

## 2.0.0 (2023-04-16)

- Drop support for Ruby 2. Please upgrade your Rails application to use Ruby 3.
- Add support for Ruby 3 keyword arguments (`**kwargs`) for use with
  `permit_action` and `forbid_action`.
- Target Ruby 3 in GitHub Actions.
- Deprecate support for older versions of `rspec-rails` and `pundit` in Readme.
- Deprecate support for optional arguments to `permit_action` and
  `forbid_action`.

## 1.9.0 (2023-04-16)

- Fix attribute reader name used by `permit_all_actions` matcher.
- Migrate from Travis CI to GitHub Actions (test and rubocop actions)
- Improve Rubocop configuration / fix offenses
- Add SimpleCov code coverage
- Update development dependencies
- Readme improvements

## 1.8.4 (2022-11-06)

- Use `require_relative` to load new files so that they can be found from within
  the gem (was not applied in 1.8.2).

## 1.8.3 (2022-11-06)

- Ensure that all files within the lib directory are loaded from the gem.

## 1.8.2 (2022-11-06)

- No changes.

## 1.8.1 (2022-11-06)

- Add back open-ended dependency on rspec-rails >= 3 (removed in v1.8.0).

## 1.8.0 (2022-11-06)

- Add `permit_all_actions` and `forbid_all_actions` matchers.
- Add Contributor Covenant Code of Conduct.
- Move code repository to a new GitHub organisation.

## 1.7.0 (2021-07-04)

- Update Ruby, Bundler, and gem versions used in development/test environments.
- Show a warning when `is_expected.not_to permit_actions` is attempted.
- Allow a series of parameters to be passed to `permit_actions` and
  `forbid_actions`

## 1.6.0 (2018-05-26)

- Allow `permit_mass_assignment_of` and `forbid_mass_assignment_of` to accept
  an array of attributes for testing the mass asignment of multiple attributes.

## 1.5.1 (2018-05-12)

- Remove configuration from being in a seperate file (to get gem working again).

## 1.5.0 (2018-05-12)

- Add support for configuring a custom user alias globally.

## 1.4.1 (2017-10-31)

- Fix `permit_actions` and `forbid_actions` matchers that were still not working
  with a singular action.

## 1.4.0 (2017-10-30)

- Add a changelog going back to the 1.0.0 release.
- Remove requirement that `permit_actions` and `forbid_actions` matchers check
  more than one action.
- Add a list of which actions are mismatched to failure messages.

## 1.3.1 (2017-08-02)

- Remove mention of `record` from error messages, since the record may be
  undefined.

## 1.3.0 (2017-06-04)

- Add support for a second parameter in `permit_action` and `forbid_action`
  matchers, containing arguments.

## 1.2.3 (2017-03-13)

- Rollback the attempt to split matchers file into smaller files.

## 1.2.2 (2017-03-13)

- Attempt to get split matchers file working inside of gem.

## 1.2.1 (2017-03-13)

- Attempt to get split matchers file working inside of gem.

## 1.2.0 (2017-03-13)

- Add RSpec to the project, along with specs for existing matchers.
- Add `permit_actions` and `forbid_actions` matchers.
- Prevent "instance variable not initialized" warnings from appearing in the
  test output.
- Attempt to split matchers file into smaller files.

## 1.1.0 (2016-06-15)

- Add `for_action` matcher that can be chained to `mass_assignment_of` matchers.
- Change the word 'performing' to 'authorising' in failure messages.
- Fix `forbid_mass_assignment_of` matcher which was checking the opposite
  condition.

## 1.0.2 (2016-03-09)

- Simplify gem dependencies to support RSpec 3.5 beta (and Rails 5).

## 1.0.1 (2016-02-25)

- Require rspec/core explicitly.

## 1.0.0 (2016-01-14)

- Initial stable release.
