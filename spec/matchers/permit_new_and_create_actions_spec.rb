# frozen_string_literal: true

require 'rspec/core'

describe 'permit_new_and_create_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when new? and create? are both permitted' do
    let(:policy_class) do
      Class.new(DummyPolicy) do
        def new?
          true
        end

        def create?
          true
        end
      end
    end

    it { is_expected.to permit_new_and_create_actions }
  end

  context 'when new? is permitted, create? is forbidden' do
    let(:policy_class) do
      Class.new(DummyPolicy) do
        def new?
          true
        end

        def create?
          false
        end
      end
    end

    it { is_expected.not_to permit_new_and_create_actions }
  end

  context 'when new? is forbidden, create? is permitted' do
    let(:policy_class) do
      Class.new(DummyPolicy) do
        def new?
          false
        end

        def create?
          true
        end
      end
    end

    it { is_expected.not_to permit_new_and_create_actions }
  end

  context 'when new? and create? are both forbidden' do
    let(:policy_class) do
      Class.new(DummyPolicy) do
        def new?
          false
        end

        def create?
          false
        end
      end
    end

    it { is_expected.not_to permit_new_and_create_actions }
  end
end
