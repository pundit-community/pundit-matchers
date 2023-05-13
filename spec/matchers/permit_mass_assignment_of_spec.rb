# frozen_string_literal: true

RSpec.describe 'permit_mass_assignment_of matcher' do
  context 'when the foo and bar attributes are permitted' do
    subject(:policy) { policy_factory(permitted_attributes: %i[foo bar]) }

    it { is_expected.to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar baz]) }

    context 'when no attributes are given' do
      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_mass_assignment_of([])
        end.to fail_with('At least one attribute must be specified when using the permit_mass_assignment_of matcher.')
      end
    end

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_mass_assignment_of(:baz)
      end.to fail_with('TestPolicy expected to permit the mass assignment of the attributes [:baz], ' \
                       'but forbade the mass assignment of the attributes [:baz] for "user".')
    end

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to permit_mass_assignment_of(:bar)
      end.to fail_with('TestPolicy expected to forbid the mass assignment of the attributes [:bar], ' \
                       'but forbade the mass assignment of the attributes [] for "user".')
    end
  end

  context 'when only the foo attribute is permitted' do
    subject(:policy) { policy_factory(permitted_attributes: %i[foo]) }

    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[bar]) }
    it { is_expected.not_to permit_mass_assignment_of(:bar) }
    it { is_expected.to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.to permit_mass_assignment_of(:foo) }
  end

  context 'when the foo and bar attributes are not permitted' do
    subject(:policy) { policy_factory(permitted_attributes: []) }

    it { is_expected.not_to permit_mass_assignment_of(%i[foo bar]) }
    it { is_expected.not_to permit_mass_assignment_of(%i[foo]) }
    it { is_expected.not_to permit_mass_assignment_of(:foo) }
    it { is_expected.not_to permit_mass_assignment_of(:baz) }
  end

  context 'when the foo and bar attributes are permitted for the test action' do
    subject(:policy) { policy_factory(permitted_attributes_for_test: %i[foo bar]) }

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

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_mass_assignment_of(:baz).for_action(:test)
      end.to fail_with('TestPolicy expected to permit the mass assignment of the attributes [:baz] ' \
                       'when authorising the test action, ' \
                       'but forbade the mass assignment of the attributes [:baz] for "user".')
    end

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to permit_mass_assignment_of(:bar).for_action(:test)
      end.to fail_with('TestPolicy expected to forbid the mass assignment of the attributes [:bar] ' \
                       'when authorising the test action, ' \
                       'but forbade the mass assignment of the attributes [] for "user".')
    end
  end

  context 'when only the foo attribute is permitted for the test action' do
    subject(:policy) { policy_factory(permitted_attributes_for_test: %i[foo]) }

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
    subject(:policy) { policy_factory(permitted_attributes_for_test: []) }

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
