require 'rspec/core'

describe 'permit_mass_assignment_of matcher' do
  context 'test attribute is a permitted attribute' do
    before do
      class PermitMassAssignmentOfPolicy1
        def permitted_attributes
          [:test]
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy1.new }
    it { is_expected.to permit_mass_assignment_of(:test) }
  end

  context 'test attribute is not a permitted attribute' do
    before do
      class PermitMassAssignmentOfPolicy2
        def permitted_attributes
          []
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy2.new }
    it { is_expected.not_to permit_mass_assignment_of(:test) }
  end

  context 'test attribute is a permitted attribute for test action' do
    before do
      class PermitMassAssignmentOfPolicy3
        def permitted_attributes_for_test
          [:test]
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy3.new }
    it { is_expected.to permit_mass_assignment_of(:test).for_action(:test) }
  end

  context 'test attribute is not a permitted attribute for test action' do
    before do
      class PermitMassAssignmentOfPolicy4
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy4.new }
    it { is_expected.not_to permit_mass_assignment_of(:test).for_action(:test) }
  end
end
