require 'rspec/core'

describe 'forbid_mass_assignments_of matcher' do
  context 'when the foo and bar attributes are permitted' do
    before(:all) do
      class ForbidMassAssignmentsOfPolicy1
        def permitted_attributes
          [:foo, :bar]
        end
      end
    end

    subject { ForbidMassAssignmentsOfPolicy1.new }
    it { is_expected.not_to forbid_mass_assignments_of([:foo, :bar]) }
    it { is_expected.not_to forbid_mass_assignments_of([:foo]) }
  end

  context 'when only the foo attribute is permitted' do
    before(:all) do
      class ForbidMassAssignmentsOfPolicy2
        def permitted_attributes
          [:foo]
        end
      end
    end

    subject { ForbidMassAssignmentsOfPolicy2.new }
    it { is_expected.not_to forbid_mass_assignments_of([:foo, :bar]) }
    it { is_expected.to forbid_mass_assignments_of([:bar]) }
  end

  context 'when the foo and bar attributes are not permitted' do
    before(:all) do
      class ForbidMassAssignmentsOfPolicy3
        def permitted_attributes
          []
        end
      end
    end

    subject { ForbidMassAssignmentsOfPolicy3.new }
    it { is_expected.to forbid_mass_assignments_of([:foo, :bar]) }
    it { is_expected.to forbid_mass_assignments_of([:foo]) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentsOfTestPolicy4
        def permitted_attributes_for_test
          [:foo, :bar]
        end
      end
    end

    subject { ForbidMassAssignmentsOfTestPolicy4.new }
    it { is_expected.not_to forbid_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.not_to forbid_mass_assignments_of([:foo]).for_action(:test) }
  end

  context 'when only the foo attribute is permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentsOfTestPolicy5
        def permitted_attributes_for_test
          [:foo]
        end
      end
    end

    subject { ForbidMassAssignmentsOfTestPolicy5.new }
    it { is_expected.not_to forbid_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.to forbid_mass_assignments_of([:bar]).for_action(:test) }
  end

  context 'when the foo and bar attributes are not permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentsOfTestPolicy6
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { ForbidMassAssignmentsOfTestPolicy6.new }
    it { is_expected.to forbid_mass_assignments_of([:foo, :bar]).for_action(:test) }
    it { is_expected.to forbid_mass_assignments_of([:foo]).for_action(:test) }
  end
end
