# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module PermitActions
      def permit_action(action)
        PermitActionsMatcher.new(action)
      end

      def permit_actions(*actions)
        PermitActionsMatcher.new(*actions)
      end

      def permit_new_and_create_actions
        PermitActionsMatcher.new(:new, :create)
      end

      def permit_edit_and_update_actions
        PermitActionsMatcher.new(:edit, :update)
      end

      class PermitActionsMatcher < Pundit::Matchers::ActionsMatcher
        def matches?(policy)
          raise ArgumentError, 'At least one action must be specified' if expected_actions.count < 1

          super

          @actual_actions = expected_actions & policy_info.forbidden_actions

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
