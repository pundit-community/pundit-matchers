require 'rspec/core'
require 'pry'

describe 'forbid_mass_assignment_of matcher' do
  context 'when the foo and bar attributes are permitted' do
    before(:all) do
      class ForbidMassAssignmentOfPolicy1
        def permitted_attributes
          [:foo, :bar]
        end
      end
    end

    subject { ForbidMassAssignmentOfPolicy1.new }
    it { is_expected.not_to forbid_mass_assignment_of([:foo, :bar]) }
    it { is_expected.not_to forbid_mass_assignment_of([:foo]) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo) }
    it { is_expected.to forbid_mass_assignment_of([:baz]) }
    it { is_expected.to forbid_mass_assignment_of(:baz) }
  end

  context 'when only the foo attribute is permitted' do
    before(:all) do
      class ForbidMassAssignmentOfPolicy2
        def permitted_attributes
          [:foo]
        end
      end
    end

    subject { ForbidMassAssignmentOfPolicy2.new }
    it { is_expected.not_to forbid_mass_assignment_of([:foo, :bar]) }
    it { is_expected.to forbid_mass_assignment_of([:bar]) }
    it { is_expected.to forbid_mass_assignment_of(:bar) }
    it { is_expected.not_to forbid_mass_assignment_of([:foo]) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo) }
  end

  context 'when the foo and bar attributes are not permitted' do
    before(:all) do
      class ForbidMassAssignmentOfPolicy3
        def permitted_attributes
          []
        end
      end
    end

    subject { ForbidMassAssignmentOfPolicy3.new }
    it { is_expected.to forbid_mass_assignment_of([:foo, :bar]) }
    it { is_expected.to forbid_mass_assignment_of([:foo]) }
    it { is_expected.to forbid_mass_assignment_of(:foo) }
    it { is_expected.to forbid_mass_assignment_of(:baz) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentOfTestPolicy4
        def permitted_attributes_for_test
          [:foo, :bar]
        end
      end
    end

    subject { ForbidMassAssignmentOfTestPolicy4.new }
    it { is_expected.not_to forbid_mass_assignment_of([:foo, :bar]).for_action(:test) }
    it { is_expected.not_to forbid_mass_assignment_of([:foo]).for_action(:test) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of([:baz]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end

  context 'when only the foo attribute is permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentOfTestPolicy5
        def permitted_attributes_for_test
          [:foo]
        end
      end
    end

    subject { ForbidMassAssignmentOfTestPolicy5.new }
    it { is_expected.not_to forbid_mass_assignment_of([:foo, :bar]).for_action(:test) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of([:bar]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of([:baz]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end

  context 'when the foo and bar attributes are not permitted for the test action' do
    before(:all) do
      class ForbidMassAssignmentOfTestPolicy6
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { ForbidMassAssignmentOfTestPolicy6.new }
    it { is_expected.to forbid_mass_assignment_of([:foo, :bar]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of([:foo]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end
end
