# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      # This class provides methods to retrieve information about a policy class,
      # such as the actions it defines and which of those actions are permitted
      # or forbidden.
      class PolicyInfo
        attr_reader :policy

        # Initializes a new instance of PolicyInfo.
        #
        # @param policy [Class] The policy class to collect details about.
        def initialize(policy)
          @policy = policy
        end

        # Returns an array of all actions defined in the policy class.
        #
        # It assumes that actions are defined as public instance methods that end with a question mark.
        #
        # @return [Array<Symbol>] An array of all actions defined in the policy class.
        def actions
          @actions ||= policy_public_methods.grep(/\?$/).sort.map do |policy_method|
            policy_method.to_s.delete_suffix('?').to_sym
          end
        end

        # Returns an array of all permitted actions defined in the policy class.
        #
        # @return [Array<Symbol>] An array of all permitted actions defined in the policy class.
        def permitted_actions
          @permitted_actions ||= actions.select { |action| policy.public_send(:"#{action}?") }
        end

        # Returns an array of all forbidden actions defined in the policy class.
        #
        # @return [Array<Symbol>] An array of all forbidden actions defined in the policy class.
        def forbidden_actions
          @forbidden_actions ||= actions - permitted_actions
        end

        private

        def policy_public_methods
          @policy_public_methods ||= policy.public_methods - Object.instance_methods
        end
      end
    end
  end
end
