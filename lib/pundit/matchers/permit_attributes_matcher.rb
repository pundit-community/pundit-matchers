# frozen_string_literal: true

require_relative 'attributes_matcher'

module Pundit
  module Matchers
    # This matcher tests whether a policy permits or forbids the mass assignment of the expected attributes.
    class PermitAttributesMatcher < AttributesMatcher
      # A description of the matcher.
      #
      # @return [String] A description of the matcher.
      def description
        "permit the mass assignment of #{expected_attributes}"
      end

      # Checks if the given policy permits the mass assignment of the expected attributes.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy permits the mass assignment of the expected attributes, false otherwise.
      def matches?(policy)
        setup_policy_info! policy
        check_actions! unless expected_actions.empty?

        @actual_attributes = expected_attributes - permitted_attributes(policy)

        actual_attributes.empty?
      end

      # Checks if the given policy forbids the mass assignment of the expected attributes.
      #
      # @param policy [Object] The policy to test.
      # @return [Boolean] True if the policy forbids the mass assignment of the expected attributes, false otherwise.
      def does_not_match?(policy)
        setup_policy_info! policy
        check_actions! unless expected_actions.empty?

        @actual_attributes = expected_attributes & permitted_attributes(policy)

        actual_attributes.empty?
      end

      # The failure message when the expected attributes are forbidden.
      #
      # @return [String] A failure message when the expected attributes are not permitted.
      def failure_message
        message = +"expected '#{policy_info}' to permit the mass assignment of #{expected_attributes}"
        message << actions_message if current_action
        message << ", but forbade the mass assignment of #{actual_attributes}"
        message << user_message
      end

      # The failure message when the expected attributes are permitted.
      #
      # @return [String] A failure message when the expected attributes are forbidden.
      def failure_message_when_negated
        message = +"expected '#{policy_info}' to forbid the mass assignment of #{expected_attributes}"
        message << actions_message if current_action
        message << ", but permitted the mass assignment of #{actual_attributes}"
        message << user_message
      end

      private

      attr_reader :actual_attributes
    end
  end
end
