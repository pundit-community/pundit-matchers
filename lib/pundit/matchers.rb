# frozen_string_literal: true

require 'rspec/core'

require_relative 'matchers/permit_actions_matcher'

require_relative 'matchers/permit_attributes_matcher'

require_relative 'matchers/forbid_all_actions_matcher'
require_relative 'matchers/forbid_only_actions_matcher'

require_relative 'matchers/permit_all_actions_matcher'
require_relative 'matchers/permit_only_actions_matcher'

module Pundit
  # Matchers module provides a set of RSpec matchers for testing Pundit policies.
  module Matchers
    # A Proc that negates the description of a matcher.
    NEGATED_DESCRIPTION = ->(description) { description.gsub(/^permit/, 'forbid') }

    # Configuration class for Pundit Matchers.
    class Configuration
      # The default user object value
      DEFAULT_USER_ALIAS = :user

      # The default user object in policies.
      # @return [Symbol|String]
      attr_accessor :default_user_alias

      # Policy-specific user objects.
      #
      # @example Use +:client+ as user alias for class +Post+
      #   config.user_aliases = { 'Post' => :client }
      #
      # @return [Hash]
      attr_accessor :user_aliases

      def initialize
        @default_user_alias = DEFAULT_USER_ALIAS
        @user_aliases = {}
      end

      # Returns the user object for the given policy.
      #
      # @return [Symbol]
      def user_alias(policy)
        user_aliases.fetch(policy.class.name, default_user_alias)
      end
    end

    class << self
      # Configures Pundit Matchers.
      #
      # @yieldparam [Configuration] configuration the configuration object to be modified.
      def configure
        yield(configuration)
      end

      # Returns the configuration object for Pundit Matchers.
      #
      # @return [Configuration] the configuration object.
      def configuration
        @configuration ||= Pundit::Matchers::Configuration.new
      end
    end

    # Creates a matcher that tests if the policy permits a given action.
    #
    # @param [Symbol] action the action to be tested.
    # @return [PermitActionsMatcher] the matcher object.
    def permit_action(action)
      PermitActionsMatcher.new(action)
    end

    # @!macro [attach] RSpec::Matchers.define_negated_matcher
    #   @!method $1
    #
    #   The negated matcher of {$2}.
    #
    #   Same as +expect(policy).not_to $2(*args)+.
    RSpec::Matchers.define_negated_matcher :forbid_action, :permit_action, &NEGATED_DESCRIPTION

    # Creates a matcher that tests if the policy permits a set of actions.
    #
    # @param [Array<Symbol>] actions the actions to be tested.
    # @return [PermitActionsMatcher] the matcher object.
    def permit_actions(*actions)
      PermitActionsMatcher.new(*actions)
    end

    RSpec::Matchers.define_negated_matcher :forbid_actions, :permit_actions, &NEGATED_DESCRIPTION

    # Creates a matcher that tests if the policy permits all actions.
    #
    # @note The negative form +not_to permit_all_actions+ is not supported
    #   since it creates ambiguity. Instead use +to forbid_all_actions+.
    #
    # @return [PermitAllActionsMatcher] the matcher object.
    def permit_all_actions
      PermitAllActionsMatcher.new
    end

    # Creates a matcher that tests if the policy forbids all actions.
    #
    # @note The negative form +not_to forbid_all_actions+ is not supported
    #   since it creates ambiguity. Instead use +to permit_all_actions+.
    #
    # @return [ForbidAllActionsMatcher] the matcher object.
    def forbid_all_actions
      ForbidAllActionsMatcher.new
    end

    # Creates a matcher that tests if the policy permits the edit and update actions.
    #
    # @return [PermitActionsMatcher] the matcher object.
    def permit_edit_and_update_actions
      PermitActionsMatcher.new(:edit, :update)
    end

    RSpec::Matchers.define_negated_matcher :forbid_edit_and_update_actions, :permit_edit_and_update_actions,
                                           &NEGATED_DESCRIPTION

    # Creates a matcher that tests if the policy permits the new and create actions.
    #
    # @return [PermitActionsMatcher] the matcher object.
    def permit_new_and_create_actions
      PermitActionsMatcher.new(:new, :create)
    end

    RSpec::Matchers.define_negated_matcher :forbid_new_and_create_actions, :permit_new_and_create_actions,
                                           &NEGATED_DESCRIPTION

    # Creates a matcher that tests if the policy permits only a set of actions.
    #
    # @note The negative form +not_to permit_only_actions+ is not supported
    #   since it creates ambiguity. Instead use +to forbid_only_actions+.
    #
    # @param [Array<Symbol>] actions the actions to be tested.
    # @return [PermitOnlyActionsMatcher] the matcher object.
    def permit_only_actions(*actions)
      PermitOnlyActionsMatcher.new(*actions)
    end

    # Creates a matcher that tests if the policy forbids only a set of actions.
    #
    # @note The negative form +not_to forbid_only_actions+ is not supported
    #   since it creates ambiguity. Instead use +to permit_only_actions+.
    #
    # @param [Array<Symbol>] actions the actions to be tested.
    # @return [ForbidOnlyActionsMatcher] the matcher object.
    def forbid_only_actions(*actions)
      ForbidOnlyActionsMatcher.new(*actions)
    end

    # Creates a matcher that tests if the policy permits mass assignment of a set of attributes.
    #
    # @param [Array<Symbol>] attributes the attributes to be tested.
    # @return [PermitAttributesMatcher] the matcher object.
    def permit_mass_assignment_of(*attributes)
      PermitAttributesMatcher.new(*attributes)
    end

    RSpec::Matchers.define_negated_matcher :forbid_mass_assignment_of, :permit_mass_assignment_of, &NEGATED_DESCRIPTION
  end
end

RSpec.configure do |config|
  config.include Pundit::Matchers
end
