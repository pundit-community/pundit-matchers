# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::OnlyActions::PermittedActionsMatcher do
  subject(:only_permitted_actions_matcher) do
    described_class.new(policy, expected_actions)
  end

  let(:policy_class) { TestCreateUpdatePolicy }
  let(:policy) { policy_class.new(create: true, update: true) }
  let(:expected_actions) { %i[create update] }

  describe '#match?' do
    context 'when policy only allows expected actions' do
      it { is_expected.to be_match }
    end

    context 'when policy allows unexpected actions' do
      let(:expected_actions) { [:create] }

      it { is_expected.not_to be_match }
    end

    context 'when policy forbids expected actions' do
      let(:expected_actions) { [:update] }

      it { is_expected.not_to be_match }
    end

    it 'does not consider action order' do
      expect(
        described_class.new(policy, expected_actions.reverse)
      ).to be_match
    end
  end

  describe '#missed_expected_actions' do
    subject(:missed_expected_actions) { only_permitted_actions_matcher.missed_expected_actions }

    context 'when policy only allows expected actions' do
      it { is_expected.to be_empty }
    end

    context 'when policy forbids expected actions' do
      let(:policy) { policy_class.new(update: true) }

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
      let(:policy) { policy_class.new }

      it { is_expected.to be_empty }
    end
  end
end
