# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_only_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when one action is permitted' do
    subject(:policy) { policy_factory(test?: true) }

    it { is_expected.to permit_only_actions([:test]) }
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are permitted' do
      subject(:policy) { policy_factory(test1?: true, test2?: true, test3?: false) }

      it { is_expected.to permit_only_actions(%i[test1 test2]) }
      it { is_expected.to permit_only_actions(%i[test2 test1]) }
      it { is_expected.not_to permit_only_actions([:test1]) }
      it { is_expected.not_to permit_only_actions([:test3]) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_only_actions([:test1])
        end.to fail_with('TestPolicy expected to have only actions [:test1] permitted, ' \
                         'but [:test2] is permitted too')
      end
    end
  end
end
