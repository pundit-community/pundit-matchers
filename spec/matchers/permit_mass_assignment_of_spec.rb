# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_mass_assignment_of matcher' do
  subject(:policy) { policy_class.new }

  context 'when the foo and bar attributes are permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          %i[foo bar]
        end
      end
    end

    it { is_expected.to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar baz]) }
  end

  context 'when only the foo attribute is permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          %i[foo]
        end
      end
    end

    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[bar]) }
    it { is_expected.not_to permit_mass_assignment_of(:bar) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
  end

  context 'when the foo and bar attributes are not permitted' do
    let(:policy_class) do
      Class.new do
        def permitted_attributes
          []
        end
      end
    end

    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.not_to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
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
      expect(policy).to permit_mass_assignment_of(%i[foo bar]).for_action(:test)
    end

    it { is_expected.to permit_mass_assignment_of(%i[foo]).for_action(:test) }
    it { is_expected.to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }

    it do
      expect(policy).not_to permit_mass_assignment_of(%i[foo bar baz])
        .for_action(:test)
    end
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
      expect(policy).not_to permit_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end

    it { is_expected.to permit_mass_assignment_of(%i[foo]).for_action(:test) }
    it { is_expected.to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }

    it do
      expect(policy).not_to permit_mass_assignment_of(%i[foo bar baz])
        .for_action(:test)
    end
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
      expect(policy).not_to permit_mass_assignment_of(%i[foo bar])
        .for_action(:test)
    end

    it do
      expect(policy).not_to permit_mass_assignment_of(%i[foo]).for_action(:test)
    end

    it { is_expected.not_to permit_mass_assignment_of(:foo).for_action(:test) }
    it { is_expected.not_to permit_mass_assignment_of(:baz).for_action(:test) }
  end
end
