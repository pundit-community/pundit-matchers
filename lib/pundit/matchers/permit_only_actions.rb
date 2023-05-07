# frozen_string_literal: true

require_relative 'only_actions_matcher'

module Pundit
  module Matchers
    module PermitOnlyActions
      def permit_only_actions(*actions)
        PermitOnlyActionsMatcher.new(*actions)
      end

      class PermitOnlyActionsMatcher < Pundit::Matchers::OnlyActionsMatcher
        def matches?(policy)
          super

          @actual_actions = policy_info.permitted_actions - expected_actions
          @unexpected_actions = policy_info.forbidden_actions & expected_actions

          actual_actions.empty? && unexpected_actions.empty?
        end

        private

        def verb
          'permit'
        end

        def unexpected_verb
          'forbade'
        end

        def other_verb
          'permitted'
        end
      end
    end
  end
end
