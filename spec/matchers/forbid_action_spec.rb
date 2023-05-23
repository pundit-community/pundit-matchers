# frozen_string_literal: true

RSpec.describe 'forbid_action matcher' do
  context 'when test? is permitted' do
    subject(:policy) { policy_factory(test?: true) }

    it { is_expected.not_to forbid_action(:test) }

    it 'provides a user friendly failure message' do
      expect do
        expect(policy).to forbid_action(:test)
      end.to fail_with('TestPolicy does not forbid test for "user".')
    end
  end

  context 'when test? is forbidden' do
    subject(:policy) { policy_factory(test?: false) }

    it { is_expected.to forbid_action(:test) }

    it 'provides a user friendly negated failure message' do
      expect do
        expect(policy).not_to forbid_action(:test)
      end.to fail_with('TestPolicy does not permit test for "user".')
    end
  end
end
