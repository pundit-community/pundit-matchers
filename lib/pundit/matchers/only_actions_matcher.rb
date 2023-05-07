# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class OnlyActionsMatcher < ActionsMatcher
      def description
        "#{verb} only #{expected_actions}"
      end

      private

      attr_reader :unexpected_actions

      def unexpected_text
        text = super

        text << " and #{unexpected_verb} #{unexpected_actions}" unless unexpected_actions.empty?

        text
      end
    end
  end
end
