# frozen_string_literal: true

RSpec.describe 'forbid_only_actions matcher' do
  context 'when one action is forbidden' do
    subject(:policy) { policy_factory(test?: false) }

    it { is_expected.to forbid_only_actions([:test]) }
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are forbidden' do
      subject(:policy) { policy_factory(test1?: false, test2?: false, test3?: true) }

      it { is_expected.to forbid_only_actions(%i[test1 test2]) }
      it { is_expected.to forbid_only_actions(%i[test2 test1]) }
      it { is_expected.not_to forbid_only_actions([:test1]) }
      it { is_expected.not_to forbid_only_actions([:test3]) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_only_actions([:test1])
        end.to fail_with('TestPolicy expected to have only actions [:test1] forbidden, ' \
                         'but [:test2] is forbidden too')
      end
    end
  end
end
