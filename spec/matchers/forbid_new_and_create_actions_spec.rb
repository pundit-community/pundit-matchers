# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'forbid_new_and_create_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when new? and create? are both permitted' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def new?
          true
        end

        def create?
          true
        end
      end
    end

    it { is_expected.not_to forbid_new_and_create_actions }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_new_and_create_actions
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                         'TestPolicy does not forbid the new or create action for "user".')
    end
  end

  context 'when new? is permitted, create? is forbidden' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def new?
          true
        end

        def create?
          false
        end
      end
    end

    it { is_expected.not_to forbid_new_and_create_actions }
  end

  context 'when new? is forbidden, create? is permitted' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def new?
          false
        end

        def create?
          true
        end
      end
    end

    it { is_expected.not_to forbid_new_and_create_actions }
  end

  context 'when new? and create? are both forbidden' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def new?
          false
        end

        def create?
          false
        end
      end
    end

    it { is_expected.to forbid_new_and_create_actions }

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to forbid_new_and_create_actions
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                         'TestPolicy does not permit the new or create action for "user".')
    end
  end
end
