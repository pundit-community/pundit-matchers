FROM ruby:3.3.6

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends

COPY Gemfile* pundit-matchers.gemspec /lib/
WORKDIR /lib
RUN gem install bundler:2.4.13
RUN bundle install

COPY . /lib

RUN bundle exec rspec
