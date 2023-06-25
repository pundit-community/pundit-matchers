# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::PolicyInfo do
  subject(:policy_info) { described_class.new(policy) }

  let(:policy) do
    policy_factory(update?: false, create?: true, new?: true,
                   user: 'Test User', custom_user: 'Custom Test User')
  end

  context 'when policy does not implement user alias method' do
    before do
      allow(Pundit::Matchers.configuration).to receive(:user_alias).and_return(:account)
    end

    it 'raises an argument error' do
      error_message = format(
        described_class::USER_NOT_IMPLEMENTED_ERROR, policy: 'TestPolicy', user_alias: 'account'
      )

      expect do
        policy_info
      end.to raise_error ArgumentError, error_message
    end
  end

  describe '#to_s' do
    subject { policy_info.to_s }

    it { is_expected.to eq 'TestPolicy' }
  end

  describe '#user' do
    subject { policy_info.user }

    it { is_expected.to eq 'Test User' }

    context 'with a custom user configuration' do
      before do
        allow(Pundit::Matchers.configuration).to receive(:user_alias).and_return(:custom_user)
      end

      it { is_expected.to eq 'Custom Test User' }
    end
  end

  describe '#actions' do
    subject(:actions) { policy_info.actions }

    it 'returns all actions alphabetically sorted' do
      expect(actions).to eq(%i[create new update])
    end
  end

  describe '#permitted_actions' do
    subject(:permitted_actions) { policy_info.permitted_actions }

    it 'returns permitted actions' do
      expect(permitted_actions).to eq(%i[create new])
    end
  end

  describe '#forbidden_actions' do
    subject(:forbidden_actions) { policy_info.forbidden_actions }

    it 'returns forbidden actions' do
      expect(forbidden_actions).to contain_exactly(:update)
    end
  end

  describe '#permitted_attributes_actions' do
    subject(:permitted_attributes_actions) { policy_info.permitted_attributes_actions }

    let(:policy) do
      policy_factory(permitted_attribues: [], permitted_attributes_for_update: [],
                     permitted_attributes_for_create: [])
    end

    it 'returns all permitted attributes actions alphabetically sorted' do
      expect(permitted_attributes_actions).to eq(%i[create update])
    end
  end
end
