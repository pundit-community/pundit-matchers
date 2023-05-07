# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    class ActionsMatcher
      def initialize(*expected_actions)
        @expected_actions = expected_actions.flatten.sort
      end

      def description
        "#{actions_text} #{expected_actions}"
      end

      def does_not_match?(*)
        raise 'Negated matcher is not supported for this matcher'
      end

      def matches?(policy)
        @policy = policy
        @policy_info = Pundit::Matchers::Utils::PolicyInfo.new(policy)
      end

      def failure_message
        message = +"#{policy_info} expected to #{verb} #{expected_actions_text},"
        message <<
          if actual_actions.empty?
            " but did not #{verb} actions"
          else
            " but #{other_verb} #{actual_actions}"
          end
        message << " for #{policy_info.user.inspect}."
        message
      end

      private

      attr_reader :expected_actions, :actual_actions, :policy, :policy_info

      def actions_text
        if expected_actions.count > 1
          "#{verb} actions"
        else
          "#{verb} action"
        end
      end

      def expected_actions_text
        expected_actions
      end

      def verb
        raise NotImplementedError
      end

      def other_verb
        raise NotImplementedError
      end
    end
  end
end
