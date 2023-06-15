# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    # This is the base action matcher class. Matchers related to actions should inherit from this class.
    class ActionsMatcher < BaseMatcher
      # Error message when actions are not implemented in a policy.
      ACTIONS_NOT_IMPLEMENTED_ERROR = "'%<policy>s' does not implement %<actions>s"
      # Error message when at least one action must be specified.
      ARGUMENTS_REQUIRED_ERROR = 'At least one action must be specified'
      # Error message when only one action may be specified.
      ONE_ARGUMENT_REQUIRED_ERROR = 'Only one action may be specified'

      # Initializes a new instance of the ActionsMatcher class.
      #
      # @param expected_actions [Array<String, Symbol>] The expected actions to be checked.
      #
      # @raise [ArgumentError] If no actions are specified.
      def initialize(*expected_actions)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_actions.empty?

        super()
        @expected_actions = expected_actions.flatten.map(&:to_sym).sort
      end

      # Ensures that only one action is specified.
      #
      # @raise [ArgumentError] If more than one action is specified.
      #
      # @return [ActionsMatcher] The object itself.
      def ensure_single_action!
        raise ArgumentError, ONE_ARGUMENT_REQUIRED_ERROR if expected_actions.size > 1

        self
      end

      private

      attr_reader :expected_actions

      def check_actions!
        non_explicit_actions = (expected_actions - policy_info.actions)
        missing_actions = non_explicit_actions.reject { |action| policy_info.policy.respond_to?("#{action}?".to_sym) }
        return if missing_actions.empty?

        raise ArgumentError, format(
          ACTIONS_NOT_IMPLEMENTED_ERROR,
          policy: policy_info, actions: missing_actions
        )
      end
    end
  end
end
