# frozen_string_literal: true

RSpec.describe Pundit::Matchers, '.configuration' do
  describe '#user_alias' do
    subject { described_class.configuration.user_alias(policy) }

    let(:policy) { policy_factory }

    it { is_expected.to eq :user }

    context 'with a different default' do
      before do
        described_class.configure do |config|
          config.default_user_alias = :account
        end
      end

      after do
        described_class.configure do |config|
          config.default_user_alias = described_class::Configuration::DEFAULT_USER_ALIAS
        end
      end

      it { is_expected.to eq :account }
    end

    context 'with a policy specific configuration' do
      before do
        described_class.configure do |config|
          config.user_aliases = { policy.class.name => :test_policy_account }
        end
      end

      after do
        described_class.configure do |config|
          config.user_aliases = {}
        end
      end

      it { is_expected.to eq :test_policy_account }
    end
  end
end
