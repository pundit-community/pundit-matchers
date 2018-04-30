require 'rspec/core'

describe 'forbid_actions matcher' do
  context 'no actions are specified' do
    before do
      class ForbidActionsTestPolicy1
      end
    end

    subject { ForbidActionsTestPolicy1.new }
    it { is_expected.not_to forbid_actions([]) }
  end

  context 'one action is specified' do
    before do
      class ForbidActionsTestPolicy2
        def test?
          true
        end
      end
    end

    subject { ForbidActionsTestPolicy2.new }
    it { is_expected.not_to forbid_actions([:test]) }
  end

  context 'more than one action is specified' do
    context 'test1? and test2? are permitted' do
      before do
        class ForbidActionsTestPolicy3
          def test1?
            true
          end

          def test2?
            true
          end
        end
      end

      subject { ForbidActionsTestPolicy3.new }
      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'test1? is permitted, test2? is forbidden' do
      before do
        class ForbidActionsTestPolicy4
          def test1?
            true
          end

          def test2?
            false
          end
        end
      end

      subject { ForbidActionsTestPolicy4.new }
      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'test1? is forbidden, test2? is permitted' do
      before do
        class ForbidActionsTestPolicy5
          def test1?
            false
          end

          def test2?
            true
          end
        end
      end

      subject { ForbidActionsTestPolicy5.new }
      it { is_expected.not_to forbid_actions(%i[test1 test2]) }
    end

    context 'test1? and test2? are both forbidden' do
      before do
        class ForbidActionsTestPolicy6
          def test1?
            false
          end

          def test2?
            false
          end
        end
      end

      subject { ForbidActionsTestPolicy6.new }
      it { is_expected.to forbid_actions(%i[test1 test2]) }
    end
  end
end
