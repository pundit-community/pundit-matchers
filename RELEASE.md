# Steps for Preparing a Release

1. Merge any relevant pull requests into the `main` branch.
2. Pull down the latest version of the `main` branch.

   `git pull origin main`

3. Checkout a new branch for the release from `main`, e.g.

   `git checkout -b release-version-1.0.0`

4. Update `CHANGELOG.md` with the current date, new gem version, and release
   notes.
5. Update the `Installation` section of `README.md` to list the new gem version.
6. Update the value of `s.version` in `pundit-matchers.gemspec` to use the new
   gem version.
7. Run the `bundle` command to include the new gem version in `Gemfile.lock`.
8. Commit the release changes to the branch, e.g:

   `git commit -am "Release version 1.0.0"`

9. Push the changes up to GitHub:

   `git push origin release-version-1.0.0`

10. Verify that all CI jobs pass.

11. Release the gem:

    `rake release`

    This command automates the gem release process by building the gem file,
    publishing it to RubyGems.org, creating a release tag with a version number
    prefixed by `v`, and pushing the tag to GitHub, simplifying the steps
    required to distribute and mark a specific version of the gem.

12. Create a GitHub release, using the tag for the release (e.g. `v1.0.0`), at
    the following URL:

    https://github.com/punditcommunity/pundit-matchers/releases/new

13. Create a pull request and, once approved, merge the release branch into
    `main`.
