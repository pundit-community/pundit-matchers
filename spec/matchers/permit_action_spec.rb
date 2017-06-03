require 'rspec/core'

describe 'permit_action matcher' do
  context 'test? is permitted' do
    before do
      class PermitActionTestPolicy1
        def test?
          true
        end
      end
    end

    subject { PermitActionTestPolicy1.new }
    it { is_expected.to permit_action(:test) }
  end

  context 'test? is forbidden' do
    before do
      class PermitActionTestPolicy2
        def test?
          false
        end
      end
    end

    subject { PermitActionTestPolicy2.new }
    it { is_expected.not_to permit_action(:test) }
  end

  context 'test_arg? is permitted' do
    before do
      class PermitActionTestPolicy3
        def test_arg?(argument)
          raise unless argument == 'argument'
          true
        end
      end
    end

    subject { PermitActionTestPolicy3.new }
    it { is_expected.to permit_action(:test_arg, 'argument') }
  end

  context 'test_arg? is forbidden' do
    before do
      class PermitActionTestPolicy4
        def test_arg?(argument)
          raise unless argument == 'argument'
          false
        end
      end
    end

    subject { PermitActionTestPolicy4.new }
    it { is_expected.not_to permit_action(:test_arg, 'argument') }
  end

  context 'test_multiple_arg? is permitted' do
    before do
      class PermitActionTestPolicy5
        def test_multiple_arg?(one, two, three)
          raise unless one == 'one' && two == 'two' && three == 'three'
          true
        end
      end
    end

    subject { PermitActionTestPolicy5.new }
    it { is_expected.to permit_action(:test_multiple_arg, 'one', 'two', 'three') }
  end

  context 'test_multiple_arg? is forbidden' do
    before do
      class PermitActionTestPolicy6
        def test_multiple_arg?(one, two, three)
          raise unless one == 'one' && two == 'two' && three == 'three'
          false
        end
      end
    end

    subject { PermitActionTestPolicy6.new }
    it { is_expected.not_to permit_action(:test_multiple_arg, 'one', 'two', 'three') }
  end
end
