# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::OnlyActions::PermittedActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::OnlyActions::PermittedActionsMatcher.new(policy, [:create])
  end

  let(:policy_class) { TestCreateUpdatePolicy }
  let(:policy) { policy_class.new(create: true, update: true) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have only actions [:create] permitted, ' \
        'but [:update] is permitted too'
      )
    end
  end

  context 'when an expectation is not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy) { policy_class.new(update: true) }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have only actions [:create] permitted, ' \
        'but [:create] is forbidden and [:update] is permitted too'
      )
    end
  end

  context 'when multiple expectations are not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy_class) do
      Class.new(TestPolicy) do
        def update?
          true
        end

        def create?
          true
        end

        def destroy?
          true
        end
      end
    end

    let(:policy) { policy_class.new }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'TestPolicy expected to have only actions [:create] permitted, ' \
        'but [:destroy, :update] are permitted too'
      )
    end
  end
end
