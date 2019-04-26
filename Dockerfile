FROM ruby:2.6

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends

COPY Gemfile* /lib/
WORKDIR /lib
RUN bundle install

COPY . /lib

RUN bundle exec rspec
