# frozen_string_literal: true

module Pundit
  module Matchers
    class ActionsMatcher
      def initialize(*expected_actions)
        @expected_actions = expected_actions.flatten.sort
      end

      def description
        "#{verb} #{actions_text} #{expected_actions}"
      end

      def does_not_match?(*)
        raise 'Negated matcher is not supported for this matcher'
      end

      def matches?(policy)
        raise ArgumentError, 'At least one action must be specified' if expected_actions.count < 1

        @policy = policy
        @policy_class = policy.class
        @user = policy.public_send(Pundit::Matchers.configuration.user_alias)
      end

      def failure_message
        message = +"#{policy_class} expected to #{verb} #{expected_actions},"
        message <<
          if actual_actions.empty?
            " but did not #{verb} actions"
          else
            " but #{other_verb} #{actual_actions}"
          end
        message << " for #{user.inspect}."
        message
      end

      private

      attr_reader :expected_actions, :actual_actions, :policy, :policy_class, :user

      def actions_text
        if expected_actions.count > 1
          'actions'
        else
          'action'
        end
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
