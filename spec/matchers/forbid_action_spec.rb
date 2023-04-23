# frozen_string_literal: true

require 'rspec/core'

describe 'forbid_action matcher' do
  subject(:policy) { policy_class.new }

  context 'when no optional arguments are specified' do
    context 'when test? is permitted' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?
            true
          end
        end
      end

      it { is_expected.not_to forbid_action(:test) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_action(:test)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'DummyPolicy does not forbid test for "user".')
      end
    end

    context 'when test? is forbidden' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?
            false
          end
        end
      end

      it { is_expected.to forbid_action(:test) }

      it 'provides a user friendly negated failure message' do
        expect do
          expect(policy).not_to forbid_action(:test)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                           'DummyPolicy does not permit test for "user".')
      end
    end
  end

  context 'when one optional argument is specified' do
    context 'when test? with optional argument is permitted' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?(argument)
            raise unless argument == 'argument'

            true
          end
        end
      end

      it { is_expected.not_to forbid_action(:test, 'argument') }
    end

    context 'when test? with optional argument is forbidden' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?(argument)
            raise unless argument == 'argument'

            false
          end
        end
      end

      it { is_expected.to forbid_action(:test, 'argument') }
    end
  end

  context 'when more than one argument is specified' do
    context 'when test? with optional arguments is permitted' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?(one, two, three)
            raise unless one == 'one' && two == 'two' && three == 'three'

            true
          end
        end
      end

      it { is_expected.not_to forbid_action(:test, 'one', 'two', 'three') }
    end

    context 'when test? with optional arguments is forbidden' do
      let(:policy_class) do
        Class.new(DummyPolicy) do
          def test?(one, two, three)
            raise unless one == 'one' && two == 'two' && three == 'three'

            false
          end
        end
      end

      it { is_expected.to forbid_action(:test, 'one', 'two', 'three') }
    end
  end
end
