# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy permits or forbids the expected actions.
    class PermitActionsMatcher < ActionsMatcher
      # A description of the matcher.
      #
      # @return [String] Description of the matcher.
      def description
        "permit #{expected_actions}"
      end

      # Checks if the given policy permits the expected actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy permits the expected actions, false otherwise.
      def matches?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = expected_actions.reject do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      # Checks if the given policy forbids the expected actions.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy forbids the expected actions, false otherwise.
      def does_not_match?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = expected_actions.select do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      # Returns a failure message when the expected actions are forbidden.
      #
      # @return [String] A failure message when the expected actions are not forbidden.
      def failure_message
        message = +"expected '#{policy_info}' to permit #{expected_actions},"
        message << " but forbade #{actual_actions}"
        message << user_message
      end

      # Returns a failure message when the expected actions are permitted.
      #
      # @return [String] A failure message when the expected actions are permitted.
      def failure_message_when_negated
        message = +"expected '#{policy_info}' to forbid #{expected_actions},"
        message << " but permitted #{actual_actions}"
        message << user_message
      end

      private

      attr_reader :actual_actions
    end
  end
end
