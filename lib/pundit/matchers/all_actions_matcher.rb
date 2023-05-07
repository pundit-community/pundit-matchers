# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    class AllActionsMatcher < ActionsMatcher
      def initialize; end

      def description
        "#{verb} all actions"
      end

      def matches?(policy)
        @policy = policy
        @policy_info = PolicyInfo.new(policy)
        @policy_class = policy.class
        @user = policy.public_send(Pundit::Matchers.configuration.user_alias)
      end

      def failure_message
        message = +"#{policy_class} expected to #{verb} all actions,"
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

      def verb
        raise NotImplementedError
      end

      def other_verb
        raise NotImplementedError
      end
    end
  end
end
