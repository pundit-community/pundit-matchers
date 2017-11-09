module Pundit
  module Matchers
    class Configuration
      attr_accessor :user_alias

      def initialize
        @user_alias = :user
      end
    end
  end
end
