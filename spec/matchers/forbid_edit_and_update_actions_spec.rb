# frozen_string_literal: true

require 'rspec/core'

describe 'forbid_edit_and_update_actions matcher' do
  subject(:policy) { policy_class.new }

  context 'when edit? and update? are both permitted' do
    let(:policy_class) do
      Class.new do
        def edit?
          true
        end

        def update?
          true
        end
      end
    end

    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'when edit? is permitted, update? is forbidden' do
    let(:policy_class) do
      Class.new do
        def edit?
          true
        end

        def update?
          false
        end
      end
    end

    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'when edit? is forbidden, update? is permitted' do
    let(:policy_class) do
      Class.new do
        def edit?
          false
        end

        def update?
          true
        end
      end
    end

    it { is_expected.not_to forbid_edit_and_update_actions }
  end

  context 'when edit? and update? are both forbidden' do
    let(:policy_class) do
      Class.new do
        def edit?
          false
        end

        def update?
          false
        end
      end
    end

    it { is_expected.to forbid_edit_and_update_actions }
  end
end
