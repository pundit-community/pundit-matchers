# Pundit Matchers

A set of RSpec matchers for testing [Pundit](https://github.com/elabs/pundit) 
authorisation policies.

## Installation

Add the following line to your Rails application's Gemfile:

`gem 'pundit-matchers'`

And then execute the following command:

`bundle`

Pundit Matchers depends on both the 
[rspec-rails](https://rubygems.org/gems/rspec-rails) and 
[pundit](https://rubygems.org/gems/pundit) gems.

## Setup

Add the following to the top of your Rails application's `spec/spec_helper.rb` file:

`require 'pundit/matchers'`

## A Basic Example of a Policy Spec

The following example shows how to test a Pundit policy which authorises 
administrators to perform all operations on articles, while visitors are only 
allowed to view articles.

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

      it { should forbid_new_and_create_actions }
    end

    context "accessing an article" do
      let(:article) { Article.create }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context "being an administrator" do
    let(:user) { User.create(administrator: true) }

    context "creating a new article" do
      let(:article) { Article.new }

      it { should permit_new_and_create_actions }
    end

    context "accessing an article" do
      let(:article) { Article.create }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
    end
  end
```
