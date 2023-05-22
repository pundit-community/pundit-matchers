# frozen_string_literal: true

RSpec.describe Pundit::Matchers::ForbidAllActionsMatcher do
  it_behaves_like 'an ambiguous negated matcher', name: 'forbid_all_actions'

  describe '#description' do
    subject { described_class.new.description }

    it { is_expected.to eq 'forbid all actions' }
  end

  describe '#matches?' do
    subject { matcher.matches?(policy) }

    let(:matcher) { described_class.new }

    context 'when all actions are forbidden' do
      let(:policy) { policy_factory(test1?: false, test2?: false) }

      it { is_expected.to be true }
    end

    context 'when some actions are forbidden' do
      let(:policy) { policy_factory(test1?: true, test2?: false) }

      it { is_expected.to be false }
    end

    context 'when all actions are permitted' do
      let(:policy) { policy_factory(test1?: true, test2?: true) }

      it { is_expected.to be false }
    end
  end

  describe '#failure_message' do
    subject(:failure_message) { matcher.failure_message }

    let(:matcher) { described_class.new }
    let(:policy) { policy_factory(test?: true) }

    before do
      matcher.matches?(policy)
    end

    it 'provides a user friendly message' do
      expect(failure_message).to eq "expected 'TestPolicy' to forbid all actions, " \
                                    "but permitted [:test] for 'user'"
    end
  end

  describe 'RSpec integration' do
    let(:failure_message) do
      "expected 'TestPolicy' to forbid all actions, but permitted [:test] for 'user'"
    end

    context 'when expectation is met' do
      subject(:policy) { policy_factory(test?: false) }

      it { is_expected.to forbid_all_actions }
    end

    context 'when expectation is not met' do
      subject(:policy) { policy_factory(test?: true) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_all_actions
        end.to fail_with(failure_message)
      end
    end
  end
end
