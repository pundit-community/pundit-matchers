require 'rspec/core'

module Pundit
  module Matchers
    RSpec::Matchers.define :forbid_action do |action, *args|
      match do |policy|
        if args.any?
          !policy.public_send("#{action}?", *args)
        else
          !policy.public_send("#{action}?")
        end
      end

      failure_message do |policy|
        "#{policy.class} does not forbid #{action} for " \
          "#{policy.user.inspect}."
      end

      failure_message_when_negated do |policy|
        "#{policy.class} does not permit #{action} for " \
          "#{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_actions do |actions|
    match do |policy|
      return false if actions.count < 1
      @allowed_actions = actions.select do |action|
        policy.public_send("#{action}?")
      end
      @allowed_actions.empty?
    end

    attr_reader :allowed_actions

    zero_actions_failure_message = 'At least one action must be ' \
      'specified when using the forbid_actions matcher.'

    failure_message do |policy|
      if actions.count == 0
        zero_actions_failure_message
      else
        "#{policy.class} expected to forbid #{actions}, but allowed " \
          "#{allowed_actions} for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if actions.count == 0
        zero_actions_failure_message
      else
        "#{policy.class} expected to permit #{actions}, but forbade " \
          "#{allowed_actions} for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_edit_and_update_actions do
    match do |policy|
      !policy.edit? && !policy.update?
    end

    failure_message do |policy|
      "#{policy.class} does not forbid the edit or update action for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not permit the edit or update action for " \
        "#{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :forbid_mass_assignment_of do |attribute|
    match do |policy|
      if defined? @action
        !policy.send("permitted_attributes_for_#{@action}").include? attribute
      else
        !policy.permitted_attributes.include? attribute
      end
    end

    chain :for_action do |action|
      @action = action
    end

    failure_message do |policy|
      if defined? @action
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if defined? @action
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_new_and_create_actions do
    match do |policy|
      !policy.new? && !policy.create?
    end

    failure_message do |policy|
      "#{policy.class} does not forbid the new or create action for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not permit the new or create action for " \
        "#{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_action do |action, *args|
    match do |policy|
      if args.any?
        policy.public_send("#{action}?", *args)
      else
        policy.public_send("#{action}?")
      end
    end

    failure_message do |policy|
      "#{policy.class} does not permit #{action} for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid #{action} for " \
        "#{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_actions do |actions|
    match do |policy|
      return false if actions.count < 1
      @forbidden_actions = actions.reject do |action|
        policy.public_send("#{action}?")
      end
      @forbidden_actions.empty?
    end

    attr_reader :forbidden_actions

    zero_actions_failure_message = 'At least one action must be specified ' \
      'when using the permit_actions matcher.'

    failure_message do |policy|
      if actions.count == 0
        zero_actions_failure_message
      else
        "#{policy.class} expected to permit #{actions}, but forbade " \
          "#{forbidden_actions} for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if actions.count == 0
        zero_actions_failure_message
      else
        "#{policy.class} expected to forbid #{actions}, but allowed " \
          "#{forbidden_actions} for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_edit_and_update_actions do
    match do |policy|
      policy.edit? && policy.update?
    end

    failure_message do |policy|
      "#{policy.class} does not permit the edit or update action for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid the edit or update action for " \
        "#{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_mass_assignment_of do |attribute|
    match do |policy|
      if defined? @action
        policy.send("permitted_attributes_for_#{@action}").include? attribute
      else
        policy.permitted_attributes.include? attribute
      end
    end

    chain :for_action do |action|
      @action = action
    end

    failure_message do |policy|
      if defined? @action
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if defined? @action
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_new_and_create_actions do
    match do |policy|
      policy.new? && policy.create?
    end

    failure_message do |policy|
      "#{policy.class} does not permit the new or create action for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid the new or create action for " \
        "#{policy.user.inspect}."
    end
  end
end

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
