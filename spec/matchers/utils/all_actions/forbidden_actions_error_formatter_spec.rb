# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::AllActions::ForbiddenActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::AllActions::ForbiddenActionsMatcher.new(policy)
  end

  let(:policy) { policy_factory(update?: true) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes missed actions in message' do
      expect(message).to eq('TestPolicy expected to have all actions forbidden, but [:update] is permitted')
    end
  end
end
