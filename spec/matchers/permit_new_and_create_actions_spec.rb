require 'rspec/core'

describe 'permit_new_and_create_actions matcher' do
  context 'new? and create? are both permitted' do
    before do
      class PermitNewAndCreateActionsTestPolicy1
        def new?
          true
        end

        def create?
          true
        end
      end
    end

    subject { PermitNewAndCreateActionsTestPolicy1.new }
    it { is_expected.to permit_new_and_create_actions }
  end

  context 'new? is permitted, create? is forbidden' do
    before do
      class PermitNewAndCreateActionsTestPolicy2
        def new?
          true
        end

        def create?
          false
        end
      end
    end

    subject { PermitNewAndCreateActionsTestPolicy2.new }
    it { is_expected.not_to permit_new_and_create_actions }
  end

  context 'new? is forbidden, create? is permitted' do
    before do
      class PermitNewAndCreateActionsTestPolicy3
        def new?
          false
        end

        def create?
          true
        end
      end
    end

    subject { PermitNewAndCreateActionsTestPolicy3.new }
    it { is_expected.not_to permit_new_and_create_actions }
  end

  context 'new? and create? are both forbidden' do
    before do
      class PermitNewAndCreateActionsTestPolicy4
        def new?
          false
        end

        def create?
          false
        end
      end
    end

    subject { PermitNewAndCreateActionsTestPolicy4.new }
    it { is_expected.not_to permit_new_and_create_actions }
  end
end
