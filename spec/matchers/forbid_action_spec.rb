require 'rspec/core'

describe 'forbid_action matcher' do
  context 'no optional arguments are specified' do
    context 'test? is permitted' do
      before do
        class ForbidActionTestPolicy1
          def test?
            true
          end
        end
      end

      subject { ForbidActionTestPolicy1.new }
      it { is_expected.not_to forbid_action(:test) }
    end

    context 'test? is forbidden' do
      before do
        class ForbidActionTestPolicy2
          def test?
            false
          end
        end
      end

      subject { ForbidActionTestPolicy2.new }
      it { is_expected.to forbid_action(:test) }
    end
  end

  context 'one optional argument is specified' do
    context 'test? with optional argument is permitted' do
      before do
        class ForbidActionTestPolicy3
          def test?(argument)
            raise unless argument == 'argument'
            true
          end
        end
      end

      subject { ForbidActionTestPolicy3.new }
      it { is_expected.not_to forbid_action(:test, 'argument') }
    end

    context 'test? with optional argument is forbidden' do
      before do
        class ForbidActionTestPolicy4
          def test?(argument)
            raise unless argument == 'argument'
            false
          end
        end
      end

      subject { ForbidActionTestPolicy4.new }
      it { is_expected.to forbid_action(:test, 'argument') }
    end
  end

  context 'more than one argument is specified' do
    context 'test? with optional arguments is permitted' do
      before do
        class ForbidActionTestPolicy5
          def test?(one, two, three)
            raise unless one == 'one' && two == 'two' && three == 'three'
            true
          end
        end
      end

      subject { ForbidActionTestPolicy5.new }
      it { is_expected.not_to forbid_action(:test, 'one', 'two', 'three') }
    end

    context 'test? with optional arguments is forbidden' do
      before do
        class ForbidActionTestPolicy6
          def test?(one, two, three)
            raise unless one == 'one' && two == 'two' && three == 'three'
            false
          end
        end
      end

      subject { ForbidActionTestPolicy6.new }
      it { is_expected.to forbid_action(:test, 'one', 'two', 'three') }
    end
  end
end
