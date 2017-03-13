require 'rspec/core'

describe 'forbid_mass_assignment_of matcher' do
  context 'test attribute is a permitted attribute' do
    before do
      class ForbidMassAssignmentOfTestPolicy1
        def permitted_attributes
          [:test]
        end
      end
    end

    subject { ForbidMassAssignmentOfTestPolicy1.new }
    it { is_expected.not_to forbid_mass_assignment_of(:test) }
  end

  context 'test attribute is not a permitted attribute' do
    before do
      class ForbidMassAssignmentOfTestPolicy2
        def permitted_attributes
          []
        end
      end
    end

    subject { ForbidMassAssignmentOfTestPolicy2.new }
    it { is_expected.to forbid_mass_assignment_of(:test) }
  end

  context 'test attribute is a permitted attribute for test action' do
    before do
      class ForbidMassAssignmentOfPolicy3
        def permitted_attributes_for_test
          [:test]
        end
      end
    end

    subject { ForbidMassAssignmentOfPolicy3.new }
    it { is_expected.not_to forbid_mass_assignment_of(:test).for_action(:test) }
  end

  context 'test attribute is not a permitted attribute for test action' do
    before do
      class ForbidMassAssignmentOfPolicy4
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { ForbidMassAssignmentOfPolicy4.new }
    it { is_expected.to forbid_mass_assignment_of(:test).for_action(:test) }
  end
end
