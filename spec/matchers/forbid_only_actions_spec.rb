# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_only_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when one action is forbidden' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          false
        end
      end
    end

    it { is_expected.to forbid_only_actions([:test]) }
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are forbidden' do
      let(:policy_class) do
        Class.new(TestPolicy) do
          def test1?
            false
          end

          def test2?
            false
          end

          def test3?
            true
          end
        end
      end

      it { is_expected.to forbid_only_actions(%i[test1 test2]) }
      it { is_expected.to forbid_only_actions(%i[test2 test1]) }
      it { is_expected.not_to forbid_only_actions([:test1]) }
      it { is_expected.not_to forbid_only_actions([:test3]) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_only_actions([:test1])
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to have only actions [:test1] forbidden, ' \
                           'but [:test2] is forbidden too')
      end
    end
  end
end
