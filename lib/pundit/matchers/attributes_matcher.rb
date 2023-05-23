# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    # The AttributesMatcher class is used to test whether a Pundit policy allows or denies access to certain attributes.
    class AttributesMatcher < BaseMatcher
      # Error message to be raised when no attributes are specified.
      ARGUMENTS_REQUIRED_ERROR = 'At least one attribute must be specified'

      # Initializes a new instance of the AttributesMatcher class.
      #
      # @param expected_attributes [Array<String, Symbol, Hash>] The list of attributes to be tested.
      def initialize(*expected_attributes)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_attributes.empty?

        super()
        @expected_attributes =
          if expected_attributes.size == 1 && expected_attributes.first.is_a?(Array)
            expected_attributes.first
          else
            expected_attributes
          end

        @options = {}
      end

      # Specifies the attributes to be tested.
      #
      # @param action [Symbol, String] The attributes to be tested.
      # @return [AttributesMatcher] The current instance of the AttributesMatcher class.
      def for_action(action)
        @options[:action] = action
        self
      end

      private

      attr_reader :expected_attributes, :options

      def permitted_attributes(policy)
        @permitted_attributes ||=
          if options.key?(:action)
            policy.public_send(:"permitted_attributes_for_#{options[:action]}")
          else
            policy.permitted_attributes
          end
      end

      def action_message
        " when authorising the '#{options[:action]}' action"
      end
    end
  end
end
