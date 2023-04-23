# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::PolicyInfo do
  subject(:policy_info) { described_class.new(policy) }

  let(:policy_class) do
    Class.new(DummyPolicy) do
      def update?
        false
      end

      def create?
        true
      end

      def new?
        true
      end
    end
  end

  let(:policy) { policy_class.new }

  describe '#actions' do
    subject(:actions) { policy_info.actions }

    it 'returns correct actions' do
      expect(actions).to match_array(%i[update create new])
    end
  end

  describe '#permitted_actions' do
    subject(:permitted_actions) { policy_info.permitted_actions }

    it 'returns actions with "true" result only' do
      expect(permitted_actions).to match_array(%i[create new])
    end
  end

  describe '#forbidden_actions' do
    subject(:forbidden_actions) { policy_info.forbidden_actions }

    it 'returns actions with "false" result only' do
      expect(forbidden_actions).to match_array(%i[update])
    end
  end
end
