# frozen_string_literal: true

require 'rspec/core'

describe Pundit::Matchers, '.configuration#user_alias' do
  subject { described_class.configuration.user_alias }

  context 'with default value' do
    it { is_expected.to eq(:user) }
  end

  context 'when value is set to :account' do
    before do
      described_class.configure do |config|
        config.user_alias = :account
      end
    end

    after do
      described_class.configure do |config|
        config.user_alias = described_class::Configuration.new.user_alias
      end
    end

    it { is_expected.to eq(:account) }
  end
end
