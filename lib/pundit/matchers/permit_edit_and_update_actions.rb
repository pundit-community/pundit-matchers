module Pundit
  module Matchers
    RSpec::Matchers.define :permit_edit_and_update_actions do
      match do |policy|
        policy.edit? && policy.update?
      end

      failure_message do |policy|
        "#{policy.class} does not permit the edit or update action on " \
          "#{policy.record} for #{policy.user.inspect}."
      end

      failure_message_when_negated do |policy|
        "#{policy.class} does not forbid the edit or update action on " \
          "#{policy.record} for #{policy.user.inspect}."
      end
    end
  end
end
