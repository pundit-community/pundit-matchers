# frozen_string_literal: true

RSpec.describe Pundit::Matchers::Utils::AllActions::ForbiddenActionsMatcher do
  subject(:only_permitted_actions_matcher) do
    described_class.new(policy)
  end

  let(:policy_class) { TestCreateUpdatePolicy }
  let(:policy) { policy_class.new }

  describe '#match?' do
    context 'when policy forbids all actions' do
      it { is_expected.to be_match }
    end

    context 'when policy allows all actions' do
      let(:policy) { policy_class.new(create: true, update: true) }

      it { is_expected.not_to be_match }
    end

    context 'when policy allows some actions' do
      let(:policy) { policy_class.new(update: true) }

      it { is_expected.not_to be_match }
    end
  end

  describe '#missed_expected_actions' do
    subject(:missed_expected_actions) { only_permitted_actions_matcher.missed_expected_actions }

    context 'when policy forbids all actions' do
      it { is_expected.to be_empty }
    end

    context 'when policy allows all actions' do
      let(:policy) { policy_class.new(create: true, update: true) }

      it 'returns actions which are permitted' do
        expect(missed_expected_actions).to match_array(%i[create update])
      end
    end

    context 'when policy allows some actions' do
      let(:policy) { policy_class.new(update: true) }

      it 'returns actions which are permitted' do
        expect(missed_expected_actions).to match_array(%i[update])
      end
    end
  end
end
