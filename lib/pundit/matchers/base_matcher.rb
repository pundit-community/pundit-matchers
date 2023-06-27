# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    # This is the base class for all matchers in the Pundit Matchers library.
    class BaseMatcher
      include ::RSpec::Matchers::Composable

      # Error message when an ambiguous negated matcher is used.
      AMBIGUOUS_NEGATED_MATCHER_ERROR = <<~MSG
        `expect().not_to %<name>s` is not supported since it creates ambiguity.
      MSG

      private

      attr_reader :policy_info

      def setup_policy_info!(policy)
        @policy_info = Pundit::Matchers::Utils::PolicyInfo.new(policy)
      end

      def user_message
        " for '#{policy_info.user}'"
      end
    end
  end
end
