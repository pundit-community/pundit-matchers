# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy permits all actions.
    class PermitAllActionsMatcher < BaseMatcher
      # A description of the matcher.
      #
      # @return [String] A description of the matcher.
      def description
        'permit all actions'
      end

      # Checks if the given policy permits all actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy permits all actions, false otherwise.
      def matches?(policy)
        setup_policy_info! policy

        policy_info.forbidden_actions.empty?
      end

      # Raises a NotImplementedError
      # @raise NotImplementedError
      # @return [void]
      def does_not_match?(_policy)
        raise NotImplementedError, format(AMBIGUOUS_NEGATED_MATCHER_ERROR, name: 'permit_all_actions')
      end

      # Returns a failure message when the policy does not permit all actions.
      #
      # @return [String] A failure message when the policy does not permit all actions.
      def failure_message
        message = "expected '#{policy_info}' to permit all actions,"
        message << " but forbade #{policy_info.forbidden_actions}"
        message << user_message
      end
    end
  end
end
