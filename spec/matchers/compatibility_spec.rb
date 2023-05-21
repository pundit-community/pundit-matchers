# frozen_string_literal: true

# TODO: this is a temporary spec to help the transition to matcher classes
# that should be removed once merged classes to the main branch

module PolicyFactory
  def policy_factory(**actions)
    policy_class = Class.new(TestPolicy) do
      actions.each do |action, value|
        define_method action do
          value
        end
      end
    end

    policy_class.new
  end
end

RSpec.configure do |config|
  config.include PolicyFactory
end

RSpec.describe 'Compatibility' do
  describe 'permit_action' do
    subject(:policy) { policy_factory(test1?: true, test2?: false) }

    it { is_expected.to permit_action(:test1) }
    it { is_expected.not_to permit_action(:test2) }
  end

  describe 'forbid_action' do
    subject(:policy) { policy_factory(test1?: false, test2?: true) }

    it { is_expected.to forbid_action(:test1) }
    it { is_expected.not_to forbid_action(:test2) }
  end

  describe 'permit_actions' do
    subject(:policy) { policy_factory(test1?: true, test2?: true, test3?: false) }

    it { is_expected.to permit_actions(:test1, :test2) }

    # FIXME: This test should fail because `test1` is permitted
    it { is_expected.not_to permit_actions(:test1, :test3) }
  end

  describe 'forbid_actions' do
    subject(:policy) { policy_factory(test1?: false, test2?: false, test3?: true) }

    it { is_expected.to forbid_actions(:test1, :test2) }

    # FIXME: This test should fail because `test1` is forbidden
    it { is_expected.not_to forbid_actions(:test1, :test3) }
  end

  describe 'permit_all_actions' do
    subject(:policy) { policy_factory(test1?: true) }

    it { is_expected.to permit_all_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: true, test2?: false) }

      # FIXME: This matcher should raise an exception because it is ambiguous,
      # since `test1` is permitted and it is not clear whether if "not to
      # permit all" means "permit at least one" or "forbid all"
      it { is_expected.not_to permit_all_actions }
    end
  end

  describe 'forbid_all_actions' do
    subject(:policy) { policy_factory(test1?: false) }

    it { is_expected.to forbid_all_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: false, test2?: true) }

      # FIXME: This matcher should raise an exception because it is ambiguous,
      # since `test1` is forbidden and it is not clear whether if "not to
      # forbid all" means "forbid at least one" or "permit all"
      it { is_expected.not_to forbid_all_actions }
    end
  end

  describe 'permit_edit_and_update_actions' do
    subject(:policy) { policy_factory(edit?: true, update?: true) }

    it { is_expected.to permit_edit_and_update_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(edit?: true, update?: false) }

      # FIXME: This matcher should fail because `edit` is permitted
      it { is_expected.not_to permit_edit_and_update_actions }
    end
  end

  describe 'forbid_edit_and_update_actions' do
    subject(:policy) { policy_factory(edit?: false, update?: false) }

    it { is_expected.to forbid_edit_and_update_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(edit?: false, update?: true) }

      # FIXME: This matcher should fail because `edit` is forbidden
      it { is_expected.not_to forbid_edit_and_update_actions }
    end
  end

  describe 'permit_new_and_create_actions' do
    subject(:policy) { policy_factory(new?: true, create?: true) }

    it { is_expected.to permit_new_and_create_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(new?: true, create?: false) }

      # FIXME: This matcher should fail because `new` is permitted
      it { is_expected.not_to permit_new_and_create_actions }
    end
  end

  describe 'forbid_new_and_create_actions' do
    subject(:policy) { policy_factory(new?: false, create?: false) }

    it { is_expected.to forbid_new_and_create_actions }

    context 'when negated' do
      subject(:policy) { policy_factory(new?: false, create?: true) }

      # FIXME: This matcher should fail because `new` is forbidden
      it { is_expected.not_to forbid_new_and_create_actions }
    end
  end

  describe 'permit_only_actions' do
    subject(:policy) { policy_factory(test1?: true, test2?: false) }

    it { is_expected.to permit_only_actions(%i[test1]) }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: true, test2?: true) }

      # FIXME: This matcher should raise an exception because it is ambiguous,
      # since `test1` is not the only action permitted and it is not clear
      # whether if "not to permit only" means "permit others" or "forbid this"
      it { is_expected.not_to permit_only_actions(%i[test1]) }
    end
  end

  describe 'forbid_only_actions' do
    subject(:policy) { policy_factory(test1?: false, test2?: true) }

    it { is_expected.to forbid_only_actions(%i[test1]) }

    context 'when negated' do
      subject(:policy) { policy_factory(test1?: false, test2?: false) }

      # FIXME: This matcher should raise an exception because it is ambiguous,
      # since `test1` is not the only action forbidden and it is not clear
      # whether if "not to forbid only" means "forbid others" or "permit this"
      it { is_expected.not_to forbid_only_actions(%i[test1]) }
    end
  end

  describe 'permit_mass_assignment_of' do
    subject(:policy) { policy_factory(permitted_attributes: %i[test1 test2]) }

    it { is_expected.to permit_mass_assignment_of(%i[test1 test2]) }

    context 'when negated' do
      subject(:policy) { policy_factory(permitted_attributes: %i[test1 test3]) }

      # FIXME: This matcher should fail because `test1` is permitted
      it { is_expected.not_to permit_mass_assignment_of(%i[test1 test2]) }
    end
  end

  describe 'forbid_mass_assignment_of' do
    subject(:policy) { policy_factory(permitted_attributes: %i[]) }

    it { is_expected.to forbid_mass_assignment_of(%i[test1 test2]) }

    context 'when negated' do
      subject(:policy) { policy_factory(permitted_attributes: %i[test2]) }

      # FIXME: This matcher should fail because `test1` is forbidden
      it { is_expected.not_to forbid_mass_assignment_of(%i[test1 test2]) }
    end
  end
end
