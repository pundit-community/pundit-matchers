# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module Utils
      module OnlyActions
        # Handles all the checks in `forbid_only_actions` matcher.
        class ForbiddenActionsMatcher < OnlyActions::ActionsMatcher
          private

          def actual_actions
            policy_info.forbidden_actions
          end
        end
      end
    end
  end
end
