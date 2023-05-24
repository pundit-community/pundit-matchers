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
        @expected_attributes = flatten_attributes(expected_attributes)
        @options = {}
      end

      # Specifies the action to be tested.
      #
      # @param action [Symbol, String] The action to be tested.
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
            flatten_attributes(policy.public_send(:"permitted_attributes_for_#{options[:action]}"))
          else
            flatten_attributes(policy.permitted_attributes)
          end
      end

      def action_message
        " when authorising the '#{options[:action]}' action"
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
    end
  end
end
