# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class AllActionsMatcher < ActionsMatcher
      private

      def actions_text
        verb
      end

      def expected_actions_text
        'all actions'
      end
    end
  end
end
