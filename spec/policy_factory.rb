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

class DynamicTestPolicy < TestPolicy
  def method_missing(method, *args, &block)
    method_s = method.to_s
    return super unless method_s.end_with?('?')

    method_s.match?(/^poke/)
  end

  def respond_to_missing?(method, include_private = false)
    method.to_s.end_with?('?') || super
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
