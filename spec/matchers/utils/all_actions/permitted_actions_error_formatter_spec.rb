# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::AllActions::PermittedActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::AllActions::PermittedActionsMatcher.new(policy)
  end

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    let(:policy) { policy_factory(create?: false, update?: true) }

    it 'includes missed actions in message' do
      expect(message).to eq('TestPolicy expected to have all actions permitted, but [:create] is forbidden')
    end
  end

  context 'when multiple expectations are not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy) { policy_factory(update?: false, create?: true, destroy?: false) }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have all actions permitted, ' \
        'but [:destroy, :update] are forbidden'
      )
    end
  end
end
