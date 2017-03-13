require 'rspec/core'

describe 'forbid_edit_and_update_actions matcher' do
  context 'edit? and update? are both permitted' do
    before do
      class ForbidEditAndUpdateActionsTestPolicy1
        def edit?
          true
        end

        def update?
          true
        end
      end
    end

    subject { ForbidEditAndUpdateActionsTestPolicy1.new }
    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'edit? is permitted, update? is forbidden' do
    before do
      class ForbidEditAndUpdateActionsTestPolicy2
        def edit?
          true
        end

        def update?
          false
        end
      end
    end

    subject { ForbidEditAndUpdateActionsTestPolicy2.new }
    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'edit? is forbidden, update? is permitted' do
    before do
      class ForbidEditAndUpdateActionsTestPolicy3
        def edit?
          false
        end

        def update?
          true
        end
      end
    end

    subject { ForbidEditAndUpdateActionsTestPolicy3.new }
    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'edit? and update? are both forbidden' do
    before do
      class ForbidEditAndUpdateActionsTestPolicy4
        def edit?
          false
        end

        def update?
          false
        end
      end
    end

    subject { ForbidEditAndUpdateActionsTestPolicy4.new }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
