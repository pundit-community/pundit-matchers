# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class AllActionsMatcher < ActionsMatcher
      private

      def description
        "#{verb} all actions"
      end
    end
  end
end
