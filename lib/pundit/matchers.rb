# frozen_string_literal: true

require 'rspec/core'

module Pundit
  module Matchers
    require_relative 'matchers/utils/only_actions/forbidden_actions_error_formatter'
    require_relative 'matchers/utils/only_actions/forbidden_actions_matcher'
    require_relative 'matchers/utils/only_actions/permitted_actions_error_formatter'
    require_relative 'matchers/utils/only_actions/permitted_actions_matcher'

    require_relative 'matchers/forbid_actions'
    require_relative 'matchers/permit_actions'

    require_relative 'matchers/forbid_all_actions'
    require_relative 'matchers/permit_all_actions'

    class Configuration
      attr_accessor :user_alias

      def initialize
        @user_alias = :user
      end
    end

    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Pundit::Matchers::Configuration.new
      end
    end
  end

  ::RSpec.configure do |config|
    config.include Pundit::Matchers::PermitActions
    config.include Pundit::Matchers::ForbidActions
    config.include Pundit::Matchers::ForbidAllActions
    config.include Pundit::Matchers::PermitAllActions
  end

  RSpec::Matchers.define :forbid_mass_assignment_of do |attributes|
    # Map single object argument to an array, if necessary
    attributes = [attributes] unless attributes.is_a?(Array)

    match do |policy|
      return false if attributes.count < 1

      @allowed_attributes = attributes.select do |attribute|
        if defined? @action
          policy.send("permitted_attributes_for_#{@action}").include? attribute
        else
          policy.permitted_attributes.include? attribute
        end
      end

      @allowed_attributes.empty?
    end

    attr_reader :allowed_attributes

    chain :for_action do |action|
      @action = action
    end

    zero_attributes_failure_message = 'At least one attribute must be ' \
                                      'specified when using the forbid_mass_assignment_of matcher.'

    failure_message do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but permitted the mass assignment of the attributes ' \
          "#{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes}, but permitted the mass assignment of " \
          "the attributes #{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but permitted the mass assignment of the attributes ' \
          "#{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes}, but permitted the mass assignment of " \
          "the attributes #{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_mass_assignment_of do |attributes|
    # Map single object argument to an array, if necessary
    attributes = [attributes] unless attributes.is_a?(Array)

    match do |policy|
      return false if attributes.count < 1

      @forbidden_attributes = attributes.select do |attribute|
        if defined? @action
          !policy.send("permitted_attributes_for_#{@action}").include? attribute
        else
          !policy.permitted_attributes.include? attribute
        end
      end

      @forbidden_attributes.empty?
    end

    attr_reader :forbidden_attributes

    chain :for_action do |action|
      @action = action
    end

    zero_attributes_failure_message = 'At least one attribute must be ' \
                                      'specified when using the permit_mass_assignment_of matcher.'

    failure_message do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but forbade the mass assignment of the attributes ' \
          "#{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes}, but forbade the mass assignment of the " \
          "attributes #{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but forbade the mass assignment of the attributes ' \
          "#{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes}, but forbade the mass assignment of the " \
          "attributes #{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_only_actions do |actions|
    match do |policy|
      @matcher = Pundit::Matchers::Utils::OnlyActions::PermittedActionsMatcher.new(policy, actions)
      @matcher.match?
    end

    failure_message do
      formatter = Pundit::Matchers::Utils::OnlyActions::PermittedActionsErrorFormatter.new(@matcher)
      formatter.message
    end
  end

  RSpec::Matchers.define :forbid_only_actions do |actions|
    match do |policy|
      @matcher = Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsMatcher.new(policy, actions)
      @matcher.match?
    end

    failure_message do
      formatter = Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsErrorFormatter.new(@matcher)
      formatter.message
    end
  end
end

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
