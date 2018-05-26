require 'rspec/core'

describe 'permit_mass_assignment_of matcher' do
  context 'when the foo and bar attributes are permitted' do
    before(:all) do
      class PermitMassAssignmentOfPolicy1
        def permitted_attributes
          %i[foo bar]
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy1.new }
    it { is_expected.to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar baz]) }
  end

  context 'when only the foo attribute is permitted' do
    before(:all) do
      class PermitMassAssignmentOfPolicy2
        def permitted_attributes
          %i[foo]
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy2.new }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[bar]) }
    it { is_expected.not_to permit_mass_assignment_of(:bar) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
  end

  context 'when the foo and bar attributes are not permitted' do
    before(:all) do
      class PermitMassAssignmentOfPolicy3
        def permitted_attributes
          []
        end
      end
    end

    subject { PermitMassAssignmentOfPolicy3.new }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.not_to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    before(:all) do
      class PermitMassAssignmentOfTestPolicy4
        def permitted_attributes_for_test
          %i[foo bar]
        end
      end
    end

    subject { PermitMassAssignmentOfTestPolicy4.new }
    it do
      is_expected.to permit_mass_assignment_of(%i[foo bar]).for_action(:test)
    end
    it { is_expected.to permit_mass_assignment_of(%i[foo]).for_action(:test) }
    it { is_expected.to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }
    it do
      is_expected.not_to permit_mass_assignment_of(%i[foo bar baz])
        .for_action(:test)
    end
  end

  context 'when only the foo attribute is permitted for the test action' do
    before(:all) do
      class PermitMassAssignmentOfTestPolicy5
        def permitted_attributes_for_test
          %i[foo]
        end
      end
    end

    subject { PermitMassAssignmentOfTestPolicy5.new }
    it do
      is_expected.not_to permit_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end
    it { is_expected.to permit_mass_assignment_of(%i[foo]).for_action(:test) }
    it { is_expected.to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }
    it do
      is_expected.not_to permit_mass_assignment_of(%i[foo bar baz])
        .for_action(:test)
    end
  end

  context 'when the foo and bar attributes are not permitted for the test ' \
    'action' do
    before(:all) do
      class PermitMassAssignmentOfTestPolicy6
        def permitted_attributes_for_test
          []
        end
      end
    end

    subject { PermitMassAssignmentOfTestPolicy6.new }
    it do
      is_expected.not_to permit_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end
    it do
      is_expected.not_to permit_mass_assignment_of(%i[foo]).for_action(:test)
    end
    it { is_expected.not_to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }
  end
end
