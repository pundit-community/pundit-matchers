# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'pundit-matchers'
  s.version     = '4.0.0'
  s.summary     = 'RSpec matchers for Pundit policies'
  s.description = 'A set of RSpec matchers for testing Pundit authorisation ' \
                  'policies'
  s.authors     = ['Chris Alley']
  s.email       = 'chris@chrisalley.info'
  s.files       = Dir['lib/**/*']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/pundit-community/pundit-matchers'
  s.license     = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 3.1'

  %w[core expectations mocks support].each do |name|
    s.add_dependency "rspec-#{name}", '~> 3.12'
  end
end
