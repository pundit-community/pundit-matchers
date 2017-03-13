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
end
