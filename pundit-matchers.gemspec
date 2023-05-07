# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'pundit-matchers'
  s.version     = '2.1.0'
  s.summary     = 'RSpec matchers for Pundit policies'
  s.description = 'A set of RSpec matchers for testing Pundit authorisation ' \
                  'policies'
  s.authors     = ['Chris Alley']
  s.email       = 'chris@chrisalley.info'
  s.files       = Dir['lib/**/*']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/punditcommunity/pundit-matchers'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rspec-rails', '>= 3.0.0'
  s.add_development_dependency 'pundit', '>= 2.0'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 3.0'
end
