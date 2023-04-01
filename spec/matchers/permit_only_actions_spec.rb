require 'rspec/core'

describe 'permit_only_actions matcher' do
  subject { policy_class.new }

  context 'one action is permitted' do
    let(:policy_class) do
      Class.new do
        def test?
          true
        end
      end
    end

    it { is_expected.to permit_only_actions([:test]) }
  end

  context 'more than one action is specified' do
    context 'test1? and test2? are permitted' do
      let(:policy_class) do
        Class.new do
          def test1?
            true
          end

          def test2?
            true
          end

          def test3?
            false
          end
        end
      end

      it { is_expected.to permit_only_actions([:test1, :test2]) }
      it { is_expected.to permit_only_actions([:test2, :test1]) }
      it { is_expected.not_to permit_only_actions([:test1]) }
      it { is_expected.not_to permit_only_actions([:test3]) }
    end
  end
end
