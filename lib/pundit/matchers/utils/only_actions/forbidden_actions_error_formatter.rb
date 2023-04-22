# frozen_string_literal: true

require_relative 'error_message_formatter'

module Pundit
  module Matchers
    module Utils
      module OnlyActions
        # Error message formatter for `forbid_only_actions` matcher.
        class ForbiddenActionsErrorFormatter
          include OnlyActions::ErrorMessageFormatter

          def initialize(matcher)
            @expected_kind = 'forbidden'
            @opposite_kind = 'permitted'
            @matcher = matcher
          end

          private

          attr_reader :matcher, :expected_kind, :opposite_kind
        end
      end
    end
  end
end
