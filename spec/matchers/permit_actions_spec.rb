require 'rspec/core'

describe 'permit_actions matcher' do
  context 'no actions are specified' do
    before do
      class PermitActionsTestPolicy1
      end
    end

    subject { PermitActionsTestPolicy1.new }
    it { is_expected.not_to permit_actions([]) }
  end

  context 'one action is specified' do
    before do
      class PermitActionsTestPolicy2
        def test?
          true
        end
      end
    end

    subject { PermitActionsTestPolicy2.new }
    it { is_expected.to permit_actions([:test]) }
  end

  context 'more than one action is specified' do
    context 'test1? and test2? are permitted' do
      before do
        class PermitActionsTestPolicy3
          def test1?
            true
          end

          def test2?
            true
          end
        end
      end

      subject { PermitActionsTestPolicy3.new }
      it { is_expected.to permit_actions(%i[test1 test2]) }
    end

    context 'test1? is permitted, test2? is forbidden' do
      before do
        class PermitActionsTestPolicy4
          def test1?
            true
          end

          def test2?
            false
          end
        end
      end

      subject { PermitActionsTestPolicy4.new }
      it { is_expected.not_to permit_actions(%i[test1 test2]) }
    end

    context 'test1? is forbidden, test2? is permitted' do
      before do
        class PermitActionsTestPolicy5
          def test1?
            false
          end

          def test2?
            true
          end
        end
      end

      subject { PermitActionsTestPolicy5.new }
      it { is_expected.not_to permit_actions(%i[test1 test2]) }
    end

    context 'test1? and test2? are both forbidden' do
      before do
        class PermitActionsTestPolicy6
          def test1?
            false
          end

          def test2?
            false
          end
        end
      end

      subject { PermitActionsTestPolicy6.new }
      it { is_expected.not_to permit_actions(%i[test1 test2]) }
    end
  end
end
