# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_actions matcher' do
  subject(:policy) { policy_class.new }

  before { allow(Kernel).to receive(:warn) }

  context 'when using `not_to`' do
    let(:policy_class) do
      Class.new
    end

    it 'prints a warning message' do
      expect(policy).not_to permit_actions([])

      expect(Kernel).to have_received(:warn)
        .with(/Please use `\.to forbid_actions` instead/)
    end
  end

  context 'when no actions are specified' do
    let(:policy_class) do
      Class.new
    end

    it { is_expected.not_to permit_actions([]) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_actions([])
      end.to fail_with('At least one action must be specified when using the permit_actions matcher.')
    end
  end

  context 'when one action is specified' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          true
        end
      end
    end

    it { is_expected.to permit_actions([:test]) }
  end

  context 'when more than one action is specified' do
    context 'when test1? and test2? are permitted' do
      let(:policy_class) do
        Class.new(TestPolicy) do
          def test1?
            true
          end

          def test2?
            true
          end
        end
      end

      it { is_expected.to permit_actions(%i[test1 test2]) }
    end

    context 'when test1? is permitted, test2? is forbidden' do
      let(:policy_class) do
        Class.new(TestPolicy) do
          def test1?
            true
          end

          def test2?
            false
          end
        end
      end

      it { is_expected.not_to permit_actions(%i[test1 test2]) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_actions(%i[test2])
        end.to fail_with('TestPolicy expected to permit [:test2], ' \
                         'but forbade [:test2] for "user".')
      end

      it 'provides a user friendly negated failure message' do
        expect do
          expect(policy).not_to permit_actions(%i[test1])
        end.to fail_with('TestPolicy expected to forbid [:test1], ' \
                         'but permitted [] for "user".')
      end
    end

    context 'when test1? is forbidden, test2? is permitted' do
      let(:policy_class) do
        Class.new(TestPolicy) do
          def test1?
            false
          end

          def test2?
            true
          end
        end
      end

      it { is_expected.not_to permit_actions(%i[test1 test2]) }
    end

    context 'when test1? and test2? are both forbidden' do
      let(:policy_class) do
        Class.new(TestPolicy) do
          def test1?
            false
          end

          def test2?
            false
          end
        end
      end

      it { is_expected.not_to permit_actions(%i[test1 test2]) }
    end
  end
end
