# frozen_string_literal: true

class TestPolicy
  class << self
    def name
      'TestPolicy'
    end

    alias to_s name
  end

  def user
    'user'
  end
end

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
