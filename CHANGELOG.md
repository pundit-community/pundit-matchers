# Pundit Matchers

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
