# Pundit Matchers

A set of RSpec matchers for testing [Pundit](https://github.com/elabs/pundit)
authorisation policies. The matcher syntax was inspired by
[this excellent blog post](http://thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec) from Thunderbolt Labs.

## Installation

Add the following line to your Rails application's Gemfile:

`gem 'pundit-matchers'`

And then execute the following command:

`bundle`

Pundit Matchers requires that both the
[rspec-rails](https://rubygems.org/gems/rspec-rails) and
[pundit](https://rubygems.org/gems/pundit) gems are also installed.

## Setup

Add the following to the top of your Rails application's `spec/spec_helper.rb`
file:

`require 'pundit/matchers'`

## Matchers

The following RSpec matchers can now be used in your the Pundit policy spec
files (by convention, saved in the `spec/policies` directory).

### Permit Matchers

* `permit_action(:action_name)` Tests that the action, passed in as a parameter,
  is permitted by the policy.
* `permit_new_and_create_actions` Tests that both the new and create actions
  are permitted by the policy.
* `permit_edit_and_update_actions` Tests that both the edit and update actions
  are permitted by the policy.
* `permit_mass_assignment_of(:attribute_name)` Tests that mass assignment of the
  attribute, passed in as a parameter, is permitted by the policy.

### Forbid Matchers

* `forbid_action(:action_name)` Tests that the action, passed in as a parameter,
  is not permitted by the policy.
* `forbid_new_and_create_actions` Tests that both the new and create actions
  are not permitted by the policy.
* `forbid_edit_and_update_actions` Tests that both the edit and update actions
  are not permitted by the policy.
* `forbid_mass_assignment_of(:attribute_name)` Tests that mass assignment of the
  attribute, passed in as a parameter, is not permitted by the policy.

## A Basic Example of a Policy Spec

The following example shows how to structure a Pundit policy spec (in this
example, the spec would be located in `spec/policies/article_policy_spec.rb`)
which authorises administrators to view and destroy articles, while visitors
are only authorised to access the show action and are forbidden to destroy
articles.

```ruby
require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:article) { Article.create }

  context "being a visitor" do
    let(:user) { nil }

    it { should permit_action(:show) }
    it { should forbid_action(:destroy) }
  end

  context "being an administrator" do
    let(:user) { User.create(administrator: true) }

    it { should permit_action(:show) }
    it { should permit_action(:destroy) }
  end
end
```

## A Testing Strategy

Pundit Matchers makes several assumptions about how you're going to structure
your policy spec file. First, you should declare a subject for the spec. The
subject should be a new instance of the policy class that you're testing. For
example:

```ruby
subject { ArticlePolicy.new(user, article) }
```

The subject will be implicitly referenced inside of `it` blocks throughout the
spec, whenever a permit or forbid matcher is used. The new method of the policy
class should also contain the two objects that will be used to authorise each
action within the policy, the user who is attempting access to the record and
the record which is to be authorised.

Throughout the spec, you can use `let` statements to create objects for the
user and the record which are being authorised. For example, the following
`permit_action` matcher would test that the user can destroy articles which
contain a `user_id` attribute which matches the user's ID:

```ruby
let(:user) { User.create }
let(:article) { Article.create(user_id: user.id) }

it { should permit_action(:destroy) }
```

The user and record objects used by the subject policy class will be reassigned
whenever you reassign these using the `let` keyword. This will typically be
done on a per context basis, as you will likely want to check the outcome of an
authorisation attempt using different configurations and combinations of user
and record objects based on application state. These variations should be
organised into separate RSpec context blocks, as in the previous example.

## Testing New/Create and Edit/Update Pairs

It common to write separate authorisation policies on a per action basis. A
notable exception to this is the case of new/create and edit/update action
pairs. Generally speaking you do not want to allow users to access a new or
edit form unless they were also authorised to create or update the record
associated with that form. Pundit Matchers provides four shortcut matchers to
account for these common scenarios:

* `permit_new_and_create_actions`
* `permit_edit_and_update_actions`
* `forbid_new_and_create_actions`
* `forbid_edit_and_update_actions`

The following example tests a policy which grants administrators permission to
create articles, but does not authorise visitors to do the same.

```ruby
require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:article) { Article.new }

  context "being a visitor" do
    let(:user) { nil }

    it { should forbid_new_and_create_actions }
  end

  context "being an administrator" do
    let(:user) { User.create(administrator: true) }

    it { should permit_new_and_create_actions }
  end
end
```

## Testing the Mass Assignment of Attributes

For policies that contain a `permitted_attributes` method to authorise only
particular attributes, Pundit Matchers provides two matchers to test for mass
assignment.

* `permit_mass_assignment_of(:attribute_name)`
* `forbid_mass_assignment_of(:attribute_name)`

Let's modify the earlier example which tests a policy where administrators have
permission to create articles, but visitors are not authorised to do so. In
this updated example, visitors *can* create articles but they cannot set the
publish flag.

```ruby
require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:article) { Article.new }

  context "being a visitor" do
    let(:user) { nil }

    it { should permit_new_and_create_actions }
    it { should forbid_mass_assignment_of(:publish) }
  end

  context "being an administrator" do
    let(:user) { User.create(administrator: true) }

    it { should permit_new_and_create_actions }
    it { should permit_mass_assignment_of(:publish) }
  end
end
```

## Testing Resolved Scopes

Another common scenario is to authorise particular records to be returned
in a collection, based on the particular properties of the record. To test for
this you don't need to use any matchers. Instead, you can test for the
inclusion or exclusion of a record in the resolved scope by using the `let`
keyword to create a resolved scope based on the current user and record objects
used by a `Policy::Scope` class.

For example, to test that visitors can only view published articles in
a resolved scope you could write your policy spec as follows:

```ruby
require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:resolved_scope) {
    ArticlePolicy::Scope.new(user, Article.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing a published article" do
      let(:article) { Article.create(publish: true) }  

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
    end

    context "accessing an unpublished article" do
      let(:article) { Article.create(publish: false) }

      it "excludes article from resolved scope" do
        expect(resolved_scope).not_to include(article)
      end

      it { should forbid_action(:show) }
    end
  end
end
```

The advantage of this approach is that you place all of your specifications for
authorising a particular context (user and record configuration) inside of a
single context block, regardless of whether the user is attempting to access
the record via an action or a scope.

## Putting It All Together

The following example puts all of the techniques discussed so far together in
one policy that tests multiple user and record configurations within different
context blocks. Here visitors can view published articles and create
unpublished articles, while administrators have full access to all articles.

```ruby
require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:resolved_scope) {
    ArticlePolicy::Scope.new(user, Article.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "creating a new article" do
      let(:article) { Article.new }

      it { should permit_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context "accessing a published article" do
      let(:article) { Article.create(publish: true) }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context "accessing an unpublished article" do
      let(:article) { Article.create(publish: false) }

      it "excludes article from resolved scope" do
        expect(resolved_scope).not_to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end
  end

  context "being an administrator" do
    let(:user) { User.create(administrator: true) }

    context "creating a new article" do
      let(:article) { Article.new }

      it { should permit_new_and_create_actions }
      it { should permit_mass_assignment_of(:publish) }
    end

    context "accessing a published article" do
      let(:article) { Article.create(publish: true) }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end

    context "accessing an unpublished article" do
      let(:article) { Article.create(publish: false) }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end
  end
end
```
