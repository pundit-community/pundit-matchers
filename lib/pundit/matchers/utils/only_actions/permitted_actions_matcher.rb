# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module Utils
      module OnlyActions
        # Handles all the checks in `permit_only_actions` matcher.
        class PermittedActionsMatcher < OnlyActions::ActionsMatcher
          private

          def actual_actions
            policy_info.permitted_actions
          end
        end
      end
    end
  end
end
