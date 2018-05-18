require 'rspec/core'

describe 'permit_mass_assignments_of matcher' do
  context 'when the foo and bar attributes are permitted' do
    before(:all) do
      class PermitMassAssignmentsOfPolicy1
        def permitted_attributes
          [:foo, :bar]
        end
      end
    end

    subject { PermitMassAssignmentsOfPolicy1.new }
    it { is_expected.to permit_mass_assignments_of([:foo, :bar]) }
    it { is_expected.to permit_mass_assignments_of([:foo]) }
  end

  context 'when only the foo attribute is permitted' do
    before(:all) do
      class PermitMassAssignmentsOfPolicy2
        def permitted_attributes
          [:foo]
        end
      end
    end

    subject { PermitMassAssignmentsOfPolicy2.new }
    it { is_expected.not_to permit_mass_assignments_of([:foo, :bar]) }
    it { is_expected.to permit_mass_assignments_of([:foo]) }
  end

  context 'when the foo and bar attributes are not permitted' do
    before(:all) do
      class PermitMassAssignmentsOfPolicy3
        def permitted_attributes
          []
        end
      end
    end

    subject { PermitMassAssignmentsOfPolicy3.new }
    it { is_expected.not_to permit_mass_assignments_of([:foo, :bar]) }
    it { is_expected.not_to permit_mass_assignments_of([:foo]) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    before(:all) do
      class PermitMassAssignmentsOfTestPolicy4
        def permitted_attributes_for_test
          [:foo, :bar]
        end
      end
    end

    subject { PermitMassAssignmentsOfTestPolicy4.new }
    it { is_expected.to permit_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.to permit_mass_assignments_of([:foo]).for_action(:test) }
  end

  context 'when only the foo attribute is permitted for the test action' do
    before(:all) do
      class PermitMassAssignmentsOfTestPolicy5
        def permitted_attributes_for_test
          [:foo]
        end
      end
    end

    subject { PermitMassAssignmentsOfTestPolicy5.new }
    it { is_expected.not_to permit_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.to permit_mass_assignments_of([:foo]).for_action(:test) }
  end

  context 'when the foo and bar attributes are not permitted for the test action' do
    before(:all) do
      class PermitMassAssignmentsOfTestPolicy6
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { PermitMassAssignmentsOfTestPolicy6.new }
    it { is_expected.not_to permit_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.not_to permit_mass_assignments_of([:foo]).for_action(:test) }
  end
end
