# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_actions matcher' do
  context 'when no actions are specified' do
    subject(:policy) { policy_factory }

    it { is_expected.not_to forbid_actions([]) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_actions([])
      end.to fail_with('At least one action must be specified when using the forbid_actions matcher.')
    end
  end

  context 'when one action is specified' do
    subject(:policy) { policy_factory(test?: true) }

    it { is_expected.not_to forbid_actions([:test]) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_actions([:test])
      end.to fail_with('TestPolicy expected to forbid [:test], ' \
                       'but permitted [:test] for "user".')
    end
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are permitted' do
      subject(:policy) { policy_factory(test1?: true, test2?: true) }

      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'when test1? is permitted, test2? is forbidden' do
      subject(:policy) { policy_factory(test1?: true, test2?: false) }

      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'when test1? is forbidden, test2? is permitted' do
      subject(:policy) { policy_factory(test1?: false, test2?: true) }

      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'when test1? and test2? are both forbidden' do
      subject(:policy) { policy_factory(test1?: false, test2?: false) }

      it { is_expected.to forbid_actions(%i[test1 test2]) }

      it 'provides a user friendly negated failure message' do
        expect do
          expect(policy).not_to forbid_actions(%i[test1 test2])
        end.to fail_with('TestPolicy expected to permit [:test1, :test2], ' \
                         'but forbade [] for "user".')
      end
    end
  end
end
