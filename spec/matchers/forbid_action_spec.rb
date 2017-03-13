require 'rspec/core'

describe 'forbid_action matcher' do
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
