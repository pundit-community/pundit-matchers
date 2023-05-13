# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_all_actions matcher' do
  context 'when no actions are specified' do
    subject(:policy) { policy_factory }

    it { is_expected.to forbid_all_actions }
  end

  context 'when one action is permitted' do
    subject(:policy) { policy_factory(test?: true) }

    it { is_expected.not_to forbid_all_actions }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_all_actions
      end.to fail_with('TestPolicy expected to have all actions forbidden, ' \
                       'but [:test] is permitted')
    end
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are permitted' do
      subject(:policy) { policy_factory(test1?: true, test2?: true) }

      it { is_expected.not_to forbid_all_actions }
    end

    context 'when test1? is permitted, test2? is forbidden' do
      subject(:policy) { policy_factory(test1?: true, test2?: false) }

      it { is_expected.not_to forbid_all_actions }
    end

    context 'when test1? is forbidden, test2? is permitted' do
      subject(:policy) { policy_factory(test1?: false, test2?: true) }

      it { is_expected.not_to forbid_all_actions }
    end

    context 'when test1? and test2? are both forbidden' do
      subject(:policy) { policy_factory(test1?: false, test2?: false) }

      it { is_expected.to forbid_all_actions }
    end
  end
end
