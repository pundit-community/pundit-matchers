require 'rspec/core'

describe 'permit_edit_and_update_actions matcher' do
  context 'edit? and update? are both permitted' do
    before do
      class PermitEditAndUpdateActionsPolicy1
        def edit?
          true
        end

        def update?
          true
        end
      end
    end

    subject { PermitEditAndUpdateActionsPolicy1.new }
    it { is_expected.to permit_edit_and_update_actions }
  end

  context 'edit? is permitted, update? is forbidden' do
    before do
      class PermitEditAndUpdateActionsPolicy2
        def edit?
          true
        end

        def update?
          false
        end
      end
    end

    subject { PermitEditAndUpdateActionsPolicy2.new }
    it { is_expected.not_to permit_edit_and_update_actions }
  end

  context 'edit? is forbidden, update? is permitted' do
    before do
      class PermitEditAndUpdateActionsPolicy3
        def edit?
          false
        end

        def update?
          true
        end
      end
    end

    subject { PermitEditAndUpdateActionsPolicy3.new }
    it { is_expected.not_to permit_edit_and_update_actions }
  end

  context 'edit? and update? are both forbidden' do
    before do
      class PermitEditAndUpdateActionsPolicy4
        def edit?
          false
        end

        def update?
          false
        end
      end
    end

    subject { PermitEditAndUpdateActionsPolicy4.new }
    it { is_expected.not_to permit_edit_and_update_actions }
  end
end
