module Pundit
  module Matchers
    RSpec::Matchers.define :permit_actions do |actions|
      match do |policy|
        return false if actions.count < 2
        actions.each do |action|
          return false unless policy.public_send("#{action}?")
        end
        true
      end

      zero_actions_failure_message = 'At least two actions must be ' \
        'specified when using the permit_actions matcher.'

      one_action_failure_message = 'More than one action must be specified ' \
        'when using the permit_actions matcher. To test a single action, use ' \
        'permit_action instead.'

      failure_message do |policy|
        case actions.count
        when 0
          zero_actions_failure_message
        when 1
          one_action_failure_message
        else
          "#{policy.class} does not permit #{actions} on #{policy.record} " \
            "for #{policy.user.inspect}."
        end
      end

      failure_message_when_negated do |policy|
        case actions.count
        when 0
          zero_actions_failure_message
        when 1
          one_action_failure_message
        else
          "#{policy.class} does not forbid #{actions} on #{policy.record} " \
            "for #{policy.user.inspect}."
        end
      end
    end
  end
end
