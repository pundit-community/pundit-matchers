module Pundit
  module Matchers
    RSpec::Matchers.define :forbid_mass_assignment_of do |attribute|
      match do |policy|
        if @action
          !policy.send("permitted_attributes_for_#{@action}").include? attribute
        else
          !policy.permitted_attributes.include? attribute
        end
      end

      chain :for_action do |action|
        @action = action
      end

      failure_message do |policy|
        if @action
          "#{policy.class} does not forbid the mass assignment of the " \
            "#{attribute} attribute, when authorising the #{@action} action, " \
            "for #{policy.user.inspect}."
        else
          "#{policy.class} does not forbid the mass assignment of the " \
            "#{attribute} attribute for #{policy.user.inspect}."
        end
      end

      failure_message_when_negated do |policy|
        if @action
          "#{policy.class} does not permit the mass assignment of the " \
            "#{attribute} attribute, when authorising the #{@action} action, " \
            "for #{policy.user.inspect}."
        else
          "#{policy.class} does not permit the mass assignment of the " \
            "#{attribute} attribute for #{policy.user.inspect}."
        end
      end
    end
  end
end
