# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module ForbidActions
      def forbid_action(action)
        ForbidActionsMatcher.new(action)
      end

      def forbid_actions(*actions)
        ForbidActionsMatcher.new(*actions)
      end

      def forbid_new_and_create_actions
        ForbidActionsMatcher.new(:new, :create)
      end

      def forbid_edit_and_update_actions
        ForbidActionsMatcher.new(:edit, :update)
      end

      class ForbidActionsMatcher < Pundit::Matchers::ActionsMatcher
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
