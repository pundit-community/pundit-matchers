# Pundit Matchers

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
