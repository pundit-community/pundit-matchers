# frozen_string_literal: true

# TODO: this is a temporary spec to help the transition to matcher classes
# that should be removed once merged classes to the main branch
# rubocop:disable Style/SignalException
RSpec.describe 'Compatibility' do
  describe 'permit_action' do
    subject(:policy) { policy_factory(test1?: true, test2?: false) }

    it { is_expected.to permit_action(:test1) }
    it { is_expected.not_to permit_action(:test2) }
  end

  describe 'forbid_action' do
    subject(:policy) { policy_factory(test1?: false, test2?: true) }

    it { is_expected.to forbid_action(:test1) }
    it { is_expected.not_to forbid_action(:test2) }
  end

  describe 'permit_actions' do
    subject(:policy) { policy_factory(test1?: true, test2?: true, test3?: false) }

    it { is_expected.to permit_actions(:test1, :test2) }

    it 'fails' do
      expect do
        expect(policy).not_to permit_actions(:test1, :test2)
      end.to fail
    end
  end

  describe 'forbid_actions' do
    subject(:policy) { policy_factory(test1?: false, test2?: false, test3?: true) }

    it { is_expected.to forbid_actions(:test1, :test2) }

    it 'fails' do
      expect do
        expect(policy).not_to forbid_actions(:test1, :test3)
      end.to fail
    end
  end

  describe 'permit_all_actions' do
    subject(:policy) { policy_factory(test1?: true) }

    it { is_expected.to permit_all_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: true, test2?: false) }

      it 'fails' do
        expect do
          expect(policy).not_to permit_all_actions
        end.to raise_error NotImplementedError
      end
    end
  end

  describe 'forbid_all_actions' do
    subject(:policy) { policy_factory(test1?: false) }

    it { is_expected.to forbid_all_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: false, test2?: true) }

      it 'fails' do
        expect do
          expect(policy).not_to forbid_all_actions
        end.to raise_error NotImplementedError
      end
    end
  end

  describe 'permit_edit_and_update_actions' do
    subject(:policy) { policy_factory(edit?: true, update?: true) }

    it { is_expected.to permit_edit_and_update_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(edit?: true, update?: false) }

      it 'fails' do
        expect do
          expect(policy).not_to permit_edit_and_update_actions
        end.to fail
      end
    end
  end

  describe 'forbid_edit_and_update_actions' do
    subject(:policy) { policy_factory(edit?: false, update?: false) }

    it { is_expected.to forbid_edit_and_update_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(edit?: false, update?: true) }

      it 'fails' do
        expect do
          expect(policy).not_to forbid_edit_and_update_actions
        end.to fail
      end
    end
  end

  describe 'permit_new_and_create_actions' do
    subject(:policy) { policy_factory(new?: true, create?: true) }

    it { is_expected.to permit_new_and_create_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(new?: true, create?: false) }

      it 'fails' do
        expect do
          expect(policy).not_to permit_new_and_create_actions
        end.to fail
      end
    end
  end

  describe 'forbid_new_and_create_actions' do
    subject(:policy) { policy_factory(new?: false, create?: false) }

    it { is_expected.to forbid_new_and_create_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(new?: false, create?: true) }

      it 'fails' do
        expect do
          expect(policy).not_to forbid_new_and_create_actions
        end.to fail
      end
    end
  end

  describe 'permit_only_actions' do
    subject(:policy) { policy_factory(test1?: true, test2?: false) }

    it { is_expected.to permit_only_actions(%i[test1]) }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: true, test2?: true) }

      it 'fails' do
        expect do
          expect(policy).not_to permit_only_actions(%i[test1])
        end.to raise_error NotImplementedError
      end
    end
  end

  describe 'forbid_only_actions' do
    subject(:policy) { policy_factory(test1?: false, test2?: true) }

    it { is_expected.to forbid_only_actions(%i[test1]) }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: false, test2?: false) }

      it 'fails' do
        expect do
          expect(policy).not_to forbid_only_actions(%i[test1])
        end.to raise_error NotImplementedError
      end
    end
  end

  describe 'permit_mass_assignment_of' do
    subject(:policy) { policy_factory(permitted_attributes: %i[test1 test2]) }

    it { is_expected.to permit_mass_assignment_of(%i[test1 test2]) }

    context 'when negated' do
      subject(:policy) { policy_factory(permitted_attributes: %i[test1 test3]) }

      it 'fails' do
        expect do
          expect(policy).not_to permit_mass_assignment_of(%i[test1 test2])
        end.to fail
      end
    end
  end

  describe 'forbid_mass_assignment_of' do
    subject(:policy) { policy_factory(permitted_attributes: %i[]) }

    it { is_expected.to forbid_mass_assignment_of(%i[test1 test2]) }

    context 'when negated' do
      subject(:policy) { policy_factory(permitted_attributes: %i[test2]) }

      it 'fails' do
        expect do
          expect(policy).not_to forbid_mass_assignment_of(%i[test1 test2])
        end.to fail
      end
    end
  end
end
# rubocop:enable Style/SignalException
