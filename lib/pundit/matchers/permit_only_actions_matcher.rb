# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy permits only the expected actions.
    class PermitOnlyActionsMatcher < ActionsMatcher
      # A description of the matcher.
      #
      # @return [String] A description of the matcher.
      def description
        "permit only #{expected_actions}"
      end

      # Checks if the given policy permits only the expected actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy permits only the expected actions, false otherwise.
      def matches?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = policy_info.permitted_actions - expected_actions
        @extra_actions = policy_info.forbidden_actions & expected_actions

        actual_actions.empty? && extra_actions.empty?
      end

      # Raises a NotImplementedError
      # @raise NotImplementedError
      # @return [void]
      def does_not_match?(_policy)
        raise NotImplementedError, format(AMBIGUOUS_NEGATED_MATCHER_ERROR, name: 'permit_only_actions')
      end

      # The failure message when the expected actions and the permitted actions do not match.
      #
      # @return [String] A failure message when the expected actions and the permitted actions do not match.
      def failure_message
        message = +"expected '#{policy_info}' to permit only #{expected_actions},"
        message << " but permitted #{actual_actions}" unless actual_actions.empty?
        message << extra_message unless extra_actions.empty?
        message << user_message
      end

      private

      attr_reader :actual_actions, :extra_actions

      def extra_message
        if actual_actions.empty?
          " but forbade #{extra_actions}"
        else
          " and forbade #{extra_actions}"
        end
      end
    end
  end
end
