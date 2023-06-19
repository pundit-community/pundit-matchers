# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      # This class provides methods to retrieve information about a policy class,
      # such as the actions it defines and which of those actions are permitted
      # or forbidden. It also provides a string representation of the policy class name
      # and the user object associated with the policy.
      class PolicyInfo
        # Error message when policy does not respond to `user_alias`.
        USER_NOT_IMPLEMENTED_ERROR = <<~MSG
          '%<policy>s' does not implement '%<user_alias>s'. You may want to
          configure an alias, which you can do as follows:

          Pundit::Matchers.configure do |config|
            # Alias for all policies
            config.default_user_alias = :%<user_alias>s

            # Per-policy alias
            config.user_aliases = { '%<policy>s' => :%<user_alias>s }
          end
        MSG

        attr_reader :policy

        # Initializes a new instance of PolicyInfo.
        #
        # @param policy [Class] The policy class to collect details about.
        def initialize(policy)
          @policy = policy
          check_user_alias!
        end

        # Returns a string representation of the policy class name.
        #
        # @return [String] A string representation of the policy class name.
        def to_s
          policy.class.name
        end

        # Returns the user object associated with the policy.
        #
        # @return [Object] The user object associated with the policy.
        def user
          @user ||= policy.public_send(user_alias)
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

        # Returns an array of all permitted attributes methods defined in the policy class.
        #
        # @return [Array<Symbol>] An array of all permitted attributes methods defined in the policy class.
        def permitted_attributes_actions
          @permitted_attributes_actions ||= policy_public_methods.grep(/permitted_attributes_for_.+$/).sort.map do |policy_method|
            policy_method.to_s.delete_prefix('permitted_attributes_for_').to_sym
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

        def user_alias
          @user_alias ||= Pundit::Matchers.configuration.user_alias(policy)
        end

        def check_user_alias!
          return if policy.respond_to?(user_alias)

          raise ArgumentError, format(USER_NOT_IMPLEMENTED_ERROR, policy: self, user_alias: user_alias)
        end
      end
    end
  end
end
