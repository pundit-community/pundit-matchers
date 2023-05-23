# frozen_string_literal: true

RSpec.shared_examples_for 'an actions matcher' do
  it 'initializes expected actions with a single action' do
    expect(described_class.new(:test).send(:expected_actions)).to eq %i[test]
  end

  it 'initializes expected actions with multiple actions, sorts, and normalizes them' do
    expect(described_class.new('test2', :test1).send(:expected_actions)).to eq %i[test1 test2]
  end

  it 'initializes expected actions with an array of actions and sorts them' do
    expect(described_class.new(%i[test2 test1]).send(:expected_actions)).to eq %i[test1 test2]
  end

  it 'initializes expected actions with arrays of actions and sorts them' do
    expect(described_class.new(%i[test2], %i[test1]).send(:expected_actions)).to eq %i[test1 test2]
  end

  context 'without actions' do
    it 'raises an argument error' do
      expect do
        described_class.new
      end.to raise_error ArgumentError, described_class::ARGUMENTS_REQUIRED_ERROR
    end
  end
end

RSpec.shared_examples_for 'a matcher that checks actions' do
  context 'when policy does not define an expected action' do
    let(:policy) { policy_factory }
    let(:matcher) { described_class.new(:test1) }

    it 'raises an argument error when action is not defined' do
      expect do
        subject
      end.to raise_error ArgumentError, "'TestPolicy' does not implement [:test1]"
    end
  end
end

RSpec.shared_examples_for 'an ambiguous negated matcher' do |name:, with_args: false|
  describe '#does_not_match?' do
    let(:matcher) { described_class.new(*(with_args ? :test : {})) }

    it 'raises a not implemented error' do
      expect do
        matcher.does_not_match?(nil)
      end.to raise_error NotImplementedError, format(
        described_class::AMBIGUOUS_NEGATED_MATCHER_ERROR, name: name
      )
    end
  end
end
