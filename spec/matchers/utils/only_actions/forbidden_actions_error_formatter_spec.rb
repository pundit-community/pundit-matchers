# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::OnlyActions::ForbiddenActionsMatcher.new(policy, [:create])
  end

  let(:policy_class) do
    Class.new do
      def self.name
        'DummyPolicy'
      end

      def initialize(update, create)
        @update = update
        @create = create
      end

      def update?
        @update
      end

      def create?
        @create
      end
    end
  end

  let(:policy) { policy_class.new(false, false) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes unexpected actions in message' do
      expect(message).to eq('DummyPolicy expected to have only actions [:create] forbidden, but [:update] is forbidden too')
    end
  end

  context 'when an expectation is not met' do
    let(:policy) { policy_class.new(false, true) }

    subject(:message) { error_message_formatter.message }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'DummyPolicy expected to have only actions [:create] forbidden, ' \
        'but [:create] is permitted and [:update] is forbidden too'
      )
    end
  end
end
