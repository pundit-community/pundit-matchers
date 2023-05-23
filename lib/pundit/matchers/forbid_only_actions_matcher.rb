# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy forbids only the expected actions.
    class ForbidOnlyActionsMatcher < ActionsMatcher
      # A description of the matcher.
      #
      # @return [String] Description of the matcher.
      def description
        "forbid only #{expected_actions}"
      end

      # Checks if the given policy forbids only the expected actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy forbids only the expected actions, false otherwise.
      def matches?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = policy_info.forbidden_actions - expected_actions
        @extra_actions = policy_info.permitted_actions & expected_actions

        actual_actions.empty? && extra_actions.empty?
      end

      # Raises a NotImplementedError
      # @raise NotImplementedError
      # @return [void]
      def does_not_match?(_policy)
        raise NotImplementedError, format(AMBIGUOUS_NEGATED_MATCHER_ERROR, name: 'forbid_only_actions')
      end

      # The failure message when the expected actions and the forbidden actions do not match.
      #
      # @return [String] A failure message when the expected actions and the forbidden actions do not match.
      def failure_message
        message = +"expected '#{policy_info}' to forbid only #{expected_actions},"
        message << " but forbade #{actual_actions}" unless actual_actions.empty?
        message << extra_message unless extra_actions.empty?
        message << user_message
      end

      private

      attr_reader :actual_actions, :extra_actions

      def extra_message
        if actual_actions.empty?
          " but permitted #{extra_actions}"
        else
          " and permitted #{extra_actions}"
        end
      end
    end
  end
end
