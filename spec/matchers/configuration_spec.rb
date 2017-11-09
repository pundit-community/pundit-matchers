require 'rspec/core'

describe Pundit::Matchers, '.configuration#user_alias' do
  subject { Pundit::Matchers.configuration.user_alias }

  context 'default value' do
    it { is_expected.to eq(:user) }
  end

  context 'when value is set to :account' do
    before do
      Pundit::Matchers.configure do |config|
        config.user_alias = :account
      end
    end
    it { is_expected.to eq(:account) }
  end
end
