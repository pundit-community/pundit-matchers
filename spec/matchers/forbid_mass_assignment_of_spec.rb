# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_mass_assignment_of matcher' do
  subject(:policy) { policy_class.new }

  context 'when the foo and bar attributes are permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          %i[foo bar]
        end
      end
    end

    it { is_expected.not_to forbid_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to forbid_mass_assignment_of(%i[foo]) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo) }
    it { is_expected.to forbid_mass_assignment_of(%i[baz]) }
    it { is_expected.to forbid_mass_assignment_of(:baz) }
  end

  context 'when only the foo attribute is permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          %i[foo]
        end
      end
    end

    it { is_expected.not_to forbid_mass_assignment_of(%i[foo bar]) }
    it { is_expected.to forbid_mass_assignment_of(%i[bar]) }
    it { is_expected.to forbid_mass_assignment_of(:bar) }
    it { is_expected.not_to forbid_mass_assignment_of(%i[foo]) }
    it { is_expected.not_to forbid_mass_assignment_of(:foo) }
  end

  context 'when the foo and bar attributes are not permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          []
        end
      end
    end

    it { is_expected.to forbid_mass_assignment_of(%i[foo bar]) }
    it { is_expected.to forbid_mass_assignment_of(%i[foo]) }
    it { is_expected.to forbid_mass_assignment_of(:foo) }
    it { is_expected.to forbid_mass_assignment_of(:baz) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes_for_test
          %i[foo bar]
        end
      end
    end

    it do
      expect(policy).not_to forbid_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end

    it do
      expect(policy).not_to forbid_mass_assignment_of(%i[foo]).for_action(:test)
    end

    it { is_expected.not_to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(%i[baz]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end

  context 'when only the foo attribute is permitted for the test action' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes_for_test
          %i[foo]
        end
      end
    end

    it do
      expect(policy).not_to forbid_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end

    it { is_expected.not_to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(%i[bar]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(%i[baz]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end

  context 'when the foo and bar attributes are not permitted for the test ' \
          'action' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes_for_test
          []
        end
      end
    end

    it do
      expect(policy).to forbid_mass_assignment_of(%i[foo bar]).for_action(:test)
    end

    it { is_expected.to forbid_mass_assignment_of(%i[foo]).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.to forbid_mass_assignment_of(:baz).for_action(:test) }
  end
end
