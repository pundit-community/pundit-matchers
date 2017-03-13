module Pundit
  module Matchers
    RSpec::Matchers.define :forbid_new_and_create_actions do
      match do |policy|
        !policy.new? && !policy.create?
      end

      failure_message do |policy|
        "#{policy.class} does not forbid the new or create action on " \
          "#{policy.record} for #{policy.user.inspect}."
      end

      failure_message_when_negated do |policy|
        "#{policy.class} does not permit the new or create action on " \
          "#{policy.record} for #{policy.user.inspect}."
      end
    end
  end
end
