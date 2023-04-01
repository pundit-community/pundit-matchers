# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      module OnlyActions
        # Parent class for specific only_action matcher. Should not be used directly.
        #
        # Expects methods in child class:
        # * actual_actions - list of actions which actually matches expected type.
        class ActionsMatcher
          attr_reader :policy_info, :expected_actions

          def initialize(policy, expected_actions)
            @policy_info = PolicyInfo.new(policy)
            @expected_actions = expected_actions
          end

          def match?
            missed_expected_actions.empty? &&
              actual_actions.sort == expected_actions.sort
          end

          def unexpected_actions
            @unexpected_actions ||= actual_actions - expected_actions
          end

          def missed_expected_actions
            @missed_expected_actions ||= expected_actions - actual_actions
          end

          def policy
            policy_info.policy
          end
        end
      end
    end
  end
end
