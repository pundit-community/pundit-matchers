# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy forbids all actions.
    class ForbidAllActionsMatcher < BaseMatcher
      # A description of the matcher.
      #
      # @return [String] Description of the matcher.
      def description
        'forbid all actions'
      end

      # Checks if the given policy forbids all actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy forbids all actions, false otherwise.
      def matches?(policy)
        setup_policy_info! policy

        policy_info.permitted_actions.empty?
      end

      # Raises a NotImplementedError
      # @raise NotImplementedError
      # @return [void]
      def does_not_match?(_policy)
        raise NotImplementedError, format(AMBIGUOUS_NEGATED_MATCHER_ERROR, name: 'forbid_all_actions')
      end

      # Returns a failure message if the matcher fails.
      #
      # @return [String] Failure message.
      def failure_message
        message = "expected '#{policy_info}' to forbid all actions,"
        message << " but permitted #{policy_info.permitted_actions}"
        message << user_message
      end
    end
  end
end
