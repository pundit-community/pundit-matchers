# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      # Collects all details about given policy class.
      class PolicyInfo
        attr_reader :policy

        def initialize(policy)
          @policy = policy
        end

        def actions
          @actions ||= begin
            policy_methods = @policy.public_methods - Object.instance_methods
            policy_methods.grep(/\?$/).sort.map { |policy_method| policy_method.to_s.delete_suffix('?').to_sym }
          end
        end

        def permitted_actions
          @permitted_actions ||= actions.select { |action| policy.public_send("#{action}?") }
        end

        def forbidden_actions
          @forbidden_actions ||= actions - permitted_actions
        end

        def to_s
          policy.class.to_s
        end

        def user
          @user ||= policy.public_send(Pundit::Matchers.configuration.user_alias)
        end
      end
    end
  end
end
