require 'rspec/core'

describe 'forbid_all_actions matcher' do
  subject { policy_class.new }

  context 'no actions are specified' do
    let(:policy_class) { Class.new }

    it { is_expected.to forbid_all_actions }
  end

  context 'one action is permitted' do
    let(:policy_class) do
      Class.new do
        def test?
          true
        end
      end
    end

    it { is_expected.not_to forbid_all_actions }
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
        end
      end

      it { is_expected.not_to forbid_all_actions }
    end

    context 'test1? is permitted, test2? is forbidden' do
      let(:policy_class) do
        Class.new do
          def test1?
            true
          end

          def test2?
            false
          end
        end
      end

      it { is_expected.not_to forbid_all_actions }
    end

    context 'test1? is forbidden, test2? is permitted' do
      let(:policy_class) do
        Class.new do
          def test1?
            false
          end

          def test2?
            true
          end
        end
      end

      it { is_expected.not_to forbid_all_actions }
    end

    context 'test1? and test2? are both forbidden' do
      let(:policy_class) do
        Class.new do
          def test1?
            false
          end

          def test2?
            false
          end
        end
      end

      it { is_expected.to forbid_all_actions }
    end
  end
end
