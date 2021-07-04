FROM ruby:3.0.1

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends

COPY Gemfile* /lib/
WORKDIR /lib
RUN gem install bundler:2.2.20
RUN bundle install

COPY . /lib

RUN bundle exec rspec
