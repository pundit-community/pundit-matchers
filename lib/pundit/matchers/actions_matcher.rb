# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    class ActionsMatcher
      ARGUMENTS_REQUIRED_ERROR = 'At least one action must be specified'
      POLICY_DOES_NOT_IMPLEMENT_ERROR = 'Policy does not implement %<actions>s'

      def initialize(*expected_actions)
        @expected_actions = expected_actions.flatten.sort
      end

      def description
        "#{verb} #{expected_actions}"
      end

      def does_not_match?(*)
        raise 'Negated matcher is not supported'
      end

      def matches?(policy)
        @policy = policy
        @policy_info = Pundit::Matchers::Utils::PolicyInfo.new(policy)

        check_arguments!
      end

      def failure_message
        message = +"#{policy_info} expected to #{description},"
        message << unexpected_text
        message << " for #{policy_info.user.inspect}."
        message
      end

      private

      attr_reader :expected_actions, :actual_actions, :policy, :policy_info

      def unexpected_text
        if actual_actions.empty?
          " but did not #{verb} actions"
        else
          " but #{other_verb} #{actual_actions}"
        end
      end

      def verb
        raise NotImplementedError
      end

      def other_verb
        raise NotImplementedError
      end

      def check_arguments!
        missing_actions = expected_actions - policy_info.actions
        return if missing_actions.empty?

        raise ArgumentError, format(POLICY_DOES_NOT_IMPLEMENT_ERROR, actions: missing_actions)
      end
    end
  end
end
