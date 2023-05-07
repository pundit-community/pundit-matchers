# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when no actions are specified' do
    let(:policy_class) do
      Class.new(TestPolicy)
    end

    it 'raises an argument error' do
      expect do
        expect(policy).to permit_actions
      end.to raise_error(ArgumentError, 'At least one action must be specified')
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

    it { is_expected.to permit_actions(:test) }
  end

  context 'when multiple actions are specified' do
    context 'when checking multiple forbidden actions' do
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

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_actions(:test2, :test1)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to permit [:test1, :test2], ' \
                           'but forbade [:test1, :test2] for "user".')
      end
    end

    context 'when checking a permitted action' do
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

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_actions(:test2)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to permit [:test2], ' \
                           'but forbade [:test2] for "user".')
      end
    end

    context 'when checking multiple permitted actions' do
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

      it { is_expected.to permit_actions(:test1) }
      it { is_expected.to permit_actions(:test2) }
      it { is_expected.to permit_actions(:test1, :test2) }
    end
  end
end
