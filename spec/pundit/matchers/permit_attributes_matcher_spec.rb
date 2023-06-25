# frozen_string_literal: true

RSpec.describe Pundit::Matchers::PermitAttributesMatcher do
  it_behaves_like 'a composable matcher'

  it 'initializes expected attributes with a single attribute' do
    expect(described_class.new(:test).send(:expected_attributes)).to eq %i[test]
  end

  it 'initializes expected attributes with multiple attributes and sorts them' do
    expect(described_class.new(:test2, :test1).send(:expected_attributes)).to eq %i[test1 test2]
  end

  it 'initializes expected attributes with an array of attributes and sorts them' do
    expect(described_class.new(%i[test2 test1]).send(:expected_attributes)).to eq %i[test1 test2]
  end

  it 'initializes expected attributes with nested attributes, normalizes, and sorts them' do
    expect(described_class.new(
      'test', ['foo', :bar], { key: %i[value2 value1] }, { key2: { key3: %w[value] } }
    ).send(:expected_attributes)).to eq(
      %i[bar foo key2\[key3\[value\]\] key\[value1\] key\[value2\] test]
    )
  end

  context 'without attributes' do
    it 'raises an argument error' do
      expect do
        described_class.new
      end.to raise_error ArgumentError, described_class::ARGUMENTS_REQUIRED_ERROR
    end
  end

  describe '#ensure_single_attribute!' do
    it 'allows a single nested attribute' do
      expect do
        described_class.new(test: %i[nested]).ensure_single_attribute!
      end.not_to raise_error
    end

    context 'when matcher has been initializated with more than one attribute' do
      it 'raises an argument error' do
        expect do
          described_class.new(test: %i[nest1 nest2]).ensure_single_attribute!
        end.to raise_error ArgumentError, described_class::ONE_ARGUMENT_REQUIRED_ERROR
      end
    end
  end

  describe '#description' do
    subject { described_class.new(:test).description }

    it { is_expected.to eq 'permit the mass assignment of [:test]' }
  end

  describe '#matches?' do
    subject { matcher.matches?(policy) }

    let(:matcher) { described_class.new(:test1, :test2) }

    context 'when all expected attributes are forbidden' do
      let(:policy) { policy_factory(permitted_attributes: []) }

      it { is_expected.to be false }
    end

    context 'when some expected attributes are forbidden' do
      let(:policy) { policy_factory(permitted_attributes: %i[test1]) }

      it { is_expected.to be false }
    end

    context 'when all expected attributes are permitted' do
      let(:policy) { policy_factory(permitted_attributes: %i[test1 test2]) }

      it { is_expected.to be true }
    end

    context 'with nested attributes' do
      let(:matcher) { described_class.new(test: :test1) }
      let(:policy) { policy_factory(permitted_attributes: [{ test: %i[test1 test2] }]) }

      it { is_expected.to be true }
    end
  end

  describe '#does_not_match?' do
    subject { matcher.does_not_match?(policy) }

    let(:matcher) { described_class.new(:test1, :test2) }

    context 'when all expected attributes are forbidden' do
      let(:policy) { policy_factory(permitted_attributes: []) }

      it { is_expected.to be true }
    end

    context 'when some expected attributes are forbidden' do
      let(:policy) { policy_factory(permitted_attributes: %i[test1]) }

      it { is_expected.to be false }
    end

    context 'when all expected attributes are permitted' do
      let(:policy) { policy_factory(permitted_attributes: %i[test1 test2]) }

      it { is_expected.to be false }
    end

    context 'with nested attributes' do
      let(:matcher) { described_class.new(test: :test1) }
      let(:policy) { policy_factory(permitted_attributes: [{ test: %i[test1 test2] }]) }

      it { is_expected.to be false }
    end
  end

  describe '#for_action' do
    subject { matcher.for_action(:test).matches?(policy) }

    let(:matcher) { described_class.new(:test1, :test2) }

    context 'when all expected attributes are forbidden' do
      let(:policy) do
        policy_factory(permitted_attributes: %i[test1 test2],
                       permitted_attributes_for_test: %i[test2])
      end

      it { is_expected.to be false }
    end
  end

  describe '#failure_message' do
    subject { matcher.failure_message }

    let(:matcher) { described_class.new(:test) }
    let(:policy) { policy_factory(permitted_attributes: []) }
    let(:expected_failure_message) do
      "expected 'TestPolicy' to permit the mass assignment of [:test], " \
        "but forbade the mass assignment of [:test] for 'user'"
    end

    before do
      matcher.matches?(policy)
    end

    it { is_expected.to eq expected_failure_message }

    context 'when an action is given' do
      let(:matcher) { described_class.new(:test).for_action(:test) }
      let(:policy) { policy_factory(permitted_attributes_for_test: []) }
      let(:expected_failure_message) do
        "expected 'TestPolicy' to permit the mass assignment of [:test] " \
          "when authorising the 'test' action, " \
          "but forbade the mass assignment of [:test] for 'user'"
      end

      it { is_expected.to eq expected_failure_message }
    end

    context 'with nested attributes' do
      let(:matcher) { described_class.new(test: :test1) }
      let(:policy) { policy_factory(permitted_attributes: []) }
      let(:expected_failure_message) do
        "expected 'TestPolicy' to permit the mass assignment of [:\"test[test1]\"], " \
          "but forbade the mass assignment of [:\"test[test1]\"] for 'user'"
      end

      before do
        matcher.matches?(policy)
      end

      it { is_expected.to eq expected_failure_message }
    end
  end

  describe '#failure_message_when_negated' do
    subject { matcher.failure_message_when_negated }

    let(:matcher) { described_class.new(:test) }
    let(:policy) { policy_factory(permitted_attributes: %i[test]) }
    let(:expected_failure_message) do
      "expected 'TestPolicy' to forbid the mass assignment of [:test], " \
        "but permitted the mass assignment of [:test] for 'user'"
    end

    before do
      matcher.does_not_match?(policy)
    end

    it { is_expected.to eq expected_failure_message }

    context 'when an action is given' do
      let(:matcher) { described_class.new(:test).for_action(:test) }
      let(:policy) { policy_factory(permitted_attributes_for_test: %i[test]) }
      let(:expected_failure_message) do
        "expected 'TestPolicy' to forbid the mass assignment of [:test] " \
          "when authorising the 'test' action, " \
          "but permitted the mass assignment of [:test] for 'user'"
      end

      it { is_expected.to eq expected_failure_message }
    end
  end

  describe 'RSpec integration' do
    subject(:policy) { policy_factory }

    let(:failure_message) do
      "expected 'TestPolicy' to permit the mass assignment of [:test], " \
        "but forbade the mass assignment of [:test] for 'user'"
    end

    let(:failure_message_when_negated) do
      "expected 'TestPolicy' to forbid the mass assignment of [:test], " \
        "but permitted the mass assignment of [:test] for 'user'"
    end

    it 'supports composability' do
      policy = policy_factory(permitted_attributes: %i[test1])

      expect(policy)
        .to permit_attribute(:test1)
        .and forbid_attribute(:test2)
    end

    context 'with for_action chain' do
      subject(:policy) do
        policy_factory(permitted_attributes: %i[test1 test2],
                       permitted_attributes_for_test: %i[test3])
      end

      it { is_expected.to permit_attributes(:test3).for_action(:test) }
      it { is_expected.to forbid_attributes(:test1).for_action(:test) }
    end

    context 'when expectation is met' do
      subject(:policy) { policy_factory(permitted_attributes: %i[test]) }

      it { is_expected.to permit_attributes(:test) }
      it { is_expected.not_to forbid_attributes(:test) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to forbid_attributes(:test)
        end.to fail_with(failure_message_when_negated)
      end

      it 'provides a user friendly negated failure message' do
        expect do
          expect(policy).not_to permit_attributes(:test)
        end.to fail_with(failure_message_when_negated)
      end
    end

    context 'with a single attribute matcher' do
      subject(:policy) { policy_factory(permitted_attributes: []) }

      it 'ensures that it has been called with a single attribute' do
        expect do
          expect(policy).to permit_attribute(%i[test test2])
        end.to raise_error ArgumentError, described_class::ONE_ARGUMENT_REQUIRED_ERROR
      end
    end

    context 'when expectation is not met' do
      subject(:policy) { policy_factory(permitted_attributes: []) }

      it { is_expected.not_to permit_attributes(:test) }
      it { is_expected.to forbid_attributes(:test) }

      it 'provides a user friendly failure message' do
        expect do
          expect(policy).to permit_attributes(:test)
        end.to fail_with(failure_message)
      end

      it 'provides a user friendly negated failure message' do
        expect do
          expect(policy).not_to forbid_attributes(:test)
        end.to fail_with(failure_message)
      end
    end

    describe 'single attribute matcher' do
      let(:test_matcher) { instance_double(described_class, matches?: true, ensure_single_attribute!: nil) }

      before do
        allow(described_class).to receive(:new).and_return(test_matcher)
        allow(test_matcher).to receive(:ensure_single_attribute!).and_return(test_matcher)
      end

      it 'defines permit_attribute matcher' do
        expect(policy).to permit_attribute(:test)

        expect(described_class).to have_received(:new).with(:test)
      end

      it 'ensures that it has been called with a single action' do
        expect(policy).to permit_attribute(:test)

        expect(test_matcher).to have_received(:ensure_single_attribute!)
      end
    end

    describe 'single attribute negated matcher' do
      let(:test_matcher) { instance_double(described_class, does_not_match?: true, ensure_single_attribute!: nil) }

      before do
        allow(described_class).to receive(:new).and_return(test_matcher)
        allow(test_matcher).to receive(:ensure_single_attribute!).and_return(test_matcher)
      end

      it 'defines forbid_attribute matcher' do
        expect(policy).to forbid_attribute(:test)

        expect(described_class).to have_received(:new).with(:test)
      end

      it 'ensures that it has been called with a single action' do
        expect(policy).to forbid_attribute(:test)

        expect(test_matcher).to have_received(:ensure_single_attribute!)
      end
    end

    describe 'helper matchers' do
      before do
        test_matcher = instance_double(described_class, matches?: true)
        allow(described_class).to receive(:new).and_return(test_matcher)
      end

      it 'aliases permit_mass_assignment_of to permit_attributes' do
        expect(policy).to permit_mass_assignment_of(:test)

        expect(described_class).to have_received(:new).with(:test)
      end
    end

    describe 'negated matchers' do
      before do
        test_matcher = instance_double(described_class, does_not_match?: true)
        allow(described_class).to receive(:new).and_return(test_matcher)
      end

      it 'aliases forbid_mass_assignment_of to forbid_attributes' do
        expect(policy).to forbid_mass_assignment_of(:test)

        expect(described_class).to have_received(:new).with(:test)
      end
    end
  end
end
