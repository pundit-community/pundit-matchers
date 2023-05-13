# frozen_string_literal: true

RSpec.describe 'permit_new_and_create_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when new? and create? are both permitted' do
    subject(:policy) { policy_factory(new?: true, create?: true) }

    it { is_expected.to permit_new_and_create_actions }

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to permit_new_and_create_actions
      end.to fail_with('TestPolicy does not forbid the new or create action for "user".')
    end
  end

  context 'when new? is permitted, create? is forbidden' do
    subject(:policy) { policy_factory(new?: true, create?: false) }

    it { is_expected.not_to permit_new_and_create_actions }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_new_and_create_actions
      end.to fail_with('TestPolicy does not permit the new or create action for "user".')
    end
  end

  context 'when new? is forbidden, create? is permitted' do
    subject(:policy) { policy_factory(new?: false, create?: true) }

    it { is_expected.not_to permit_new_and_create_actions }
  end

  context 'when new? and create? are both forbidden' do
    subject(:policy) { policy_factory(new?: false, create?: false) }

    it { is_expected.not_to permit_new_and_create_actions }
  end
end
