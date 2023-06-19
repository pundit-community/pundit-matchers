# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    # The AttributesMatcher class is used to test whether a Pundit policy allows or denies access to certain attributes.
    class AttributesMatcher < BaseMatcher
      # Error message when permitted attributes actions are not implemented in a policy.
      ACTIONS_NOT_IMPLEMENTED_ERROR = "'%<policy>s' does not implement permitted attributes for %<actions>s"
      # Error message to be raised when no attributes are specified.
      ARGUMENTS_REQUIRED_ERROR = 'At least one attribute must be specified'
      # Error message to be raised when only one attribute may be specified.
      ONE_ARGUMENT_REQUIRED_ERROR = 'Only one attribute may be specified'

      # Initializes a new instance of the AttributesMatcher class.
      #
      # @param expected_attributes [Array<String, Symbol, Hash>] The list of attributes to be tested.
      def initialize(*expected_attributes)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_attributes.empty?

        super()
        @expected_attributes = flatten_attributes(expected_attributes)
        @actions = {}
      end

      # Specifies the action to be tested.
      #
      # @param action [Symbol, String] The action to be tested.
      # @return [AttributesMatcher] The current instance of the AttributesMatcher class.
      def for_action(action)
        for_actions(action)
      end

      # Specifies the actions to be tested.
      #
      # @param actions [Array<String, Symbol>] The actions to be tested.
      # @return [AttributesMatcher] The current instance of the AttributesMatcher class.
      def for_actions(*actions)
        @actions = actions.map(&:to_sym).sort
      end

      # Ensures that only one attribute is specified.
      #
      # @raise [ArgumentError] If more than one attribute is specified.
      #
      # @return [AttributesMatcher] The object itself.
      def ensure_single_attribute!
        raise ArgumentError, ONE_ARGUMENT_REQUIRED_ERROR if expected_attributes.size > 1

        self
      end

      private

      attr_reader :expected_attributes, :actions, :current_action

      def permitted_attributes(policy)
        @permitted_attributes ||=
          if current_action
            flatten_attributes(policy.public_send(:"permitted_attributes_for_#{current_action}"))
          else
            flatten_attributes(policy.permitted_attributes)
          end
      end

      def action_message
        " when authorising the '#{current_action}' action"
      end

      # Flattens and sorts a hash or array of attributes into an array of symbols.
      #
      # This is a private method used internally by the `Matcher` class to convert
      # attribute lists into a flattened, sorted array of symbols. The resulting
      # array can be used to compare attribute lists.
      #
      # @param attributes [String, Symbol, Array, Hash] the attributes to be flattened.
      # @return [Array<Symbol>] the flattened, sorted array of symbols.
      def flatten_attributes(attributes)
        case attributes
        when String, Symbol
          [attributes.to_sym]
        when Array
          attributes.flat_map { |item| flatten_attributes(item) }.sort
        when Hash
          attributes.flat_map do |key, value|
            flatten_attributes(value).map { |item| :"#{key}[#{item}]" }
          end.sort
        end
      end

      def check_actions!
        non_explicit_actions = (options[:actions] - policy_info.permitted_attributes_actions)
        missing_actions = non_explicit_actions.reject do |action|
          policy_info.policy.respond_to?(:"permitted_attributes_for_#{action}?")
        end
        return if missing_actions.empty?

        raise ArgumentError, format(
          ACTIONS_NOT_IMPLEMENTED_ERROR,
          policy: policy_info, actions: missing_actions
        )
      end
    end
  end
end
