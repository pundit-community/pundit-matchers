# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      def self.to_sentence(actions)
        case actions.length
        when 0
          'no actions'
        when 1
          "'#{actions[0]}'"
        when 2
          "'#{actions[0]}' and '#{actions[1]}'"
        else
          "'#{actions[0...-1].join(', ')} and '#{actions[-1]}'"
        end
      end
    end
  end
end
