require 'rspec/core'

require 'pundit/matchers/forbid_action'
require 'pundit/matchers/forbid_actions'
require 'pundit/matchers/forbid_edit_and_update_actions'
require 'pundit/matchers/forbid_mass_assignment_of'
require 'pundit/matchers/forbid_new_and_create_actions'
require 'pundit/matchers/permit_action'
require 'pundit/matchers/permit_actions'
require 'pundit/matchers/permit_edit_and_update_actions'
require 'pundit/matchers/permit_mass_assignment_of'
require 'pundit/matchers/permit_new_and_create_actions'

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
