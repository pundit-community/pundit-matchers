# frozen_string_literal: true

RSpec.describe Pundit::Matchers::PermitOnlyActionsMatcher do
  it_behaves_like 'an ambiguous negated matcher', name: 'permit_only_actions', with_args: true
  it_behaves_like 'an actions matcher'

  describe '#description' do
    subject { described_class.new(:test).description }

    it { is_expected.to eq 'permit only [:test]' }
  end

  describe '#matches?' do
    subject { matcher.matches?(policy) }

    let(:matcher) { described_class.new(:test1) }

    it_behaves_like 'a matcher that checks actions'

    context 'when all actions are forbidden' do
      let(:policy) { policy_factory(test1?: false, test2?: false) }

      it { is_expected.to be false }
    end

    context 'when all actions are permitted' do
      let(:policy) { policy_factory(test1?: true, test2?: true) }

      it { is_expected.to be false }
    end

    context 'when expected actions are forbidden' do
      let(:policy) { policy_factory(test1?: false, test2?: true) }

      it { is_expected.to be false }
    end

    context 'when only expected actions are permitted' do
      let(:policy) { policy_factory(test1?: true, test2?: false) }

      it { is_expected.to be true }
    end
  end

  describe '#failure_message' do
    subject(:failure_message) { matcher.failure_message }

    let(:matcher) { described_class.new(:test) }
    let(:policy) { policy_factory(test?: false) }

    before do
      matcher.matches?(policy)
    end

    it 'provides a user friendly message' do
      expect(failure_message).to eq "expected 'TestPolicy' to permit only [:test], " \
                                    "but forbade [:test] for 'user'"
    end

    context 'when extra actions are permitted' do
      let(:policy) { policy_factory(test?: true, test2?: true) }

      it 'provides a user friendly message' do
        expect(failure_message).to eq "expected 'TestPolicy' to permit only [:test], " \
                                      "but permitted [:test2] for 'user'"
      end
    end

    context 'when expected action is forbidden and extra actions are permitted' do
      let(:policy) { policy_factory(test?: false, test2?: true) }

      it 'provides a user friendly message' do
        expect(failure_message).to eq "expected 'TestPolicy' to permit only [:test], " \
                                      "but permitted [:test2] and forbade [:test] for 'user'"
      end
    end
  end

  describe 'RSpec integration' do
    let(:failure_message) do
      "expected 'TestPolicy' to permit only [:test], but forbade [:test] for 'user'"
    end

    context 'when expectation is met' do
      subject(:policy) { policy_factory(test?: true) }

      it { is_expected.to permit_only_actions(:test) }
    end

    context 'when expectation is not met' do
      subject(:policy) { policy_factory(test?: false) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_only_actions(:test)
        end.to fail_with(failure_message)
      end
    end
  end
end
