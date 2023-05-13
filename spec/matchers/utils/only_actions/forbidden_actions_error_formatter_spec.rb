# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsMatcher.new(policy, [:create])
  end

  let(:policy_class) { TestCreateUpdatePolicy }
  let(:policy) { policy_class.new }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have only actions [:create] forbidden, ' \
        'but [:update] is forbidden too'
      )
    end
  end

  context 'when an expectation is not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy) { policy_class.new(create: true) }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have only actions [:create] forbidden, ' \
        'but [:create] is permitted and [:update] is forbidden too'
      )
    end
  end
end
