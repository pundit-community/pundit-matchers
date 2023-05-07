# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_all_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when no actions are specified' do
    let(:policy_class) { Class.new }

    it { is_expected.to forbid_all_actions }
  end

  context 'when one action is permitted' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          true
        end
      end
    end

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_all_actions
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                         'TestPolicy expected to forbid all actions, ' \
                         'but permitted [:test] for "user".')
    end
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

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_all_actions
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to forbid all actions, ' \
                           'but permitted [:test1, :test2] for "user".')
      end
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

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_all_actions
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to forbid all actions, ' \
                           'but permitted [:test1] for "user".')
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

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_all_actions
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to forbid all actions, ' \
                           'but permitted [:test2] for "user".')
      end
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

      it { is_expected.to forbid_all_actions }
    end
  end
end
