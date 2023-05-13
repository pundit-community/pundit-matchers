# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_edit_and_update_actions matcher' do
  context 'when edit? and update? are both permitted' do
    subject(:policy) { policy_factory(edit?: true, update?: true) }

    it { is_expected.not_to forbid_edit_and_update_actions }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_edit_and_update_actions
      end.to fail_with('TestPolicy does not forbid the edit or update action for "user".')
    end
  end

  context 'when edit? is permitted, update? is forbidden' do
    subject(:policy) { policy_factory(edit?: true, update?: false) }

    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'when edit? is forbidden, update? is permitted' do
    subject(:policy) { policy_factory(edit?: false, update?: true) }

    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'when edit? and update? are both forbidden' do
    subject(:policy) { policy_factory(edit?: false, update?: false) }

    it { is_expected.to forbid_edit_and_update_actions }

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to forbid_edit_and_update_actions
      end.to fail_with('TestPolicy does not permit the edit or update action for "user".')
    end
  end
end
