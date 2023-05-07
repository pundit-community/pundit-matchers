# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module ForbidAllActions
      def forbid_all_actions
        ForbidAllActionsMatcher.new
      end

      class ForbidAllActionsMatcher < Pundit::Matchers::AllActionsMatcher
        def matches?(policy)
          super

          @actual_actions = expected_actions.select do |action|
            policy.public_send(:"#{action}?")
          end

          actual_actions.empty?
        end

        private

        def verb
          'forbid'
        end

        def other_verb
          'permitted'
        end
      end
    end
  end
end
