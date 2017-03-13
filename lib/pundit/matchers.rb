require 'rspec/core'

require_relative './matchers/forbid_action'
require_relative './matchers/forbid_edit_and_update_actions'
require_relative './matchers/forbid_mass_assignment_of'
require_relative './matchers/forbid_new_and_create_actions'
require_relative './matchers/permit_action'
require_relative './matchers/permit_edit_and_update_actions'
require_relative './matchers/permit_mass_assignment_of'
require_relative './matchers/permit_new_and_create_actions'

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
