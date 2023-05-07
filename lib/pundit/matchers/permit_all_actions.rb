# frozen_string_literal: true

require_relative 'all_actions_matcher'

module Pundit
  module Matchers
    module PermitAllActions
      def permit_all_actions
        PermitAllActionsMatcher.new
      end

      class PermitAllActionsMatcher < Pundit::Matchers::AllActionsMatcher
        def matches?(policy)
          super

          @actual_actions = policy_info.actions & policy_info.forbidden_actions

          actual_actions.empty?
        end

        private

        def verb
          'permit'
        end

        def other_verb
          'forbade'
        end
      end
    end
  end
end
