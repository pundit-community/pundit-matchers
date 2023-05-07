# frozen_string_literal: true

require_relative 'only_actions_matcher'

module Pundit
  module Matchers
    module ForbidOnlyActions
      def forbid_only_actions(*actions)
        ForbidOnlyActionsMatcher.new(*actions)
      end

      class ForbidOnlyActionsMatcher < Pundit::Matchers::OnlyActionsMatcher
        def matches?(policy)
          super

          @actual_actions = policy_info.forbidden_actions - expected_actions
          @unexpected_actions = policy_info.permitted_actions & expected_actions

          actual_actions.empty? && unexpected_actions.empty?
        end

        private

        def verb
          'forbid'
        end

        def unexpected_verb
          'permitted'
        end

        def other_verb
          'forbade'
        end
      end
    end
  end
end
