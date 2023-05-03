# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::OnlyActions::PermittedActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::OnlyActions::PermittedActionsMatcher.new(policy, [:create])
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

  let(:policy) { policy_class.new(true, true) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'DummyPolicy expected to have only actions [:create] permitted, ' \
        'but [:update] is permitted too'
      )
    end
  end

  context 'when an expectation is not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy) { policy_class.new(true, false) }

    it 'includes unexpected actions in message' do
      expect(message).to eq(
        'DummyPolicy expected to have only actions [:create] permitted, ' \
        'but [:create] is forbidden and [:update] is permitted too'
      )
    end
  end

  context 'when multiple expectations are not met' do
    subject(:message) { error_message_formatter.message }

    let(:policy_class) do
      Class.new do
        def self.name
          'DummyPolicy'
        end

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
        'DummyPolicy expected to have only actions [:create] permitted, ' \
        'but [:destroy, :update] are permitted too'
      )
    end
  end
end
