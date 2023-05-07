# frozen_string_literal: true

module Pundit
  module Matchers
    class OnlyActionsMatcher < ActionsMatcher
      private

      def actions_text
        "#{verb} only"
      end
    end
  end
end
