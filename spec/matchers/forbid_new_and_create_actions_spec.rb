require 'rspec/core'

describe 'forbid_new_and_create_actions matcher' do
  context 'new? and create? are both permitted' do

    before do
      class ForbidNewAndCreateActionsTestPolicy1
        def new?
          true
        end

        def create?
          true
        end
      end
    end

    subject { ForbidNewAndCreateActionsTestPolicy1.new }
    it { is_expected.not_to forbid_new_and_create_actions }
  end

  context 'new? is permitted, create? is forbidden' do
    before do
      class ForbidNewAndCreateActionsTestPolicy2
        def new?
          true
        end

        def create?
          false
        end
      end
    end

    subject { ForbidNewAndCreateActionsTestPolicy2.new }
    it { is_expected.not_to forbid_new_and_create_actions }
  end

  context 'new? is forbidden, create? is permitted' do
    before do
      class ForbidNewAndCreateActionsTestPolicy3
        def new?
          false
        end

        def create?
          true
        end
      end
    end

    subject { ForbidNewAndCreateActionsTestPolicy3.new }
    it { is_expected.not_to forbid_new_and_create_actions }
  end

  context 'new? and create? are both forbidden' do
    before do
      class ForbidNewAndCreateActionsTestPolicy4
        def new?
          false
        end

        def create?
          false
        end
      end
    end

    subject { ForbidNewAndCreateActionsTestPolicy4.new }
    it { is_expected.to forbid_new_and_create_actions }
  end
end
