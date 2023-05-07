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
