# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::AllActions::ForbiddenActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::AllActions::ForbiddenActionsMatcher.new(policy)
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

  let(:policy) { policy_class.new(true, false) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes missed actions in message' do
      expect(message).to eq('DummyPolicy expected to have all actions forbidden, but [:update] is permitted')
    end
  end
end
