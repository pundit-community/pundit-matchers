# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::OnlyActions::PermittedActionsMatcher do
  subject(:only_permitted_actions_matcher) do
    described_class.new(policy, expected_actions)
  end

  let(:policy_class) do
    Class.new do
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
  let(:expected_actions) { [:create, :update] }

  describe '#match?' do
    context 'when policy only allows expected actions' do
      it { is_expected.to be_match }

      context 'when expected actions are not ordered' do
        let(:expected_actions) { [:update, :create] }

        it { is_expected.to be_match }
      end
    end

    context 'when policy allows unexpected actions' do
      let(:expected_actions) { [:create] }

      it { is_expected.not_to be_match }
    end

    context 'when policy forbids expected actions' do
      let(:expected_actions) { [:update] }

      it { is_expected.not_to be_match }
    end
  end

  describe '#missed_expected_actions' do
    subject(:missed_expected_actions) { only_permitted_actions_matcher.missed_expected_actions }

    context 'when policy only allows expected actions' do
      it { is_expected.to be_empty }
    end

    context 'when policy forbids expected actions' do
      let(:policy) { policy_class.new(true, false) }

      it 'returns actions which are permitted' do
        expect(missed_expected_actions).to match_array(%i[create])
      end
    end
  end

  describe '#unexpected_actions' do
    subject(:unexpected_actions) { only_permitted_actions_matcher.unexpected_actions }

    context 'when policy only allows expected actions' do
      it { is_expected.to be_empty }
    end

    context 'when policy allows unexpected actions' do
      let(:expected_actions) { [:create] }

      it 'returns actions which are permitted' do
        expect(unexpected_actions).to match_array(%i[update])
      end
    end

    context 'when policy forbids expected actions' do
      let(:policy) { policy_class.new(false, false) }

      it { is_expected.to be_empty }
    end
  end
end
