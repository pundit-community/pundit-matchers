# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_only_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when one action is permitted' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          true
        end
      end
    end

    it { is_expected.to permit_only_actions(:test) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_only_actions(:test2)
      end.to raise_error(ArgumentError,
                         'Policy does not implement [:test2]')
    end
  end

  context 'when all actions are forbidden' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          false
        end
      end
    end

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_only_actions(:test)
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                         'TestPolicy expected to permit only [:test], ' \
                         'but did not permit actions ' \
                         'and forbade [:test] for "user".')
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

          def test3?
            false
          end
        end
      end

      it { is_expected.to permit_only_actions(%i[test1 test2]) }
      it { is_expected.to permit_only_actions(%i[test2 test1]) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_only_actions([:test1])
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to permit only [:test1], ' \
                           'but permitted [:test2] for "user".')
      end

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_only_actions([:test3])
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to permit only [:test3], ' \
                           'but permitted [:test1, :test2] ' \
                           'and forbade [:test3] for "user".')
      end

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_only_actions(:test1, :test3)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'TestPolicy expected to permit only [:test1, :test3], ' \
                           'but permitted [:test2] ' \
                           'and forbade [:test3] for "user".')
      end
    end
  end
end
