# frozen_string_literal: true

require 'rspec/core'

RSpec.describe 'permit_action matcher' do
  subject(:policy) { policy_class.new }

  context 'when test? is permitted' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          true
        end
      end
    end

    it { is_expected.to permit_action(:test) }

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to permit_action(:test)
      end.to fail_with('TestPolicy does not forbid test for "user".')
    end
  end

  context 'when test? is forbidden' do
    let(:policy_class) do
      Class.new(TestPolicy) do
        def test?
          false
        end
      end
    end

    it { is_expected.not_to permit_action(:test) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to permit_action(:test)
      end.to fail_with('TestPolicy does not permit test for "user".')
    end
  end
end
