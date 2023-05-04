# frozen_string_literal: true

class TestPolicy
  class << self
    def name
      'TestPolicy'
    end

    alias to_s name
  end

  def initialize(*); end

  def user
    'user'
  end
end

class TestCreateUpdatePolicy < TestPolicy
  def initialize(create: false, update: false)
    super
    @create = create
    @update = update
  end

  def create?
    @create
  end

  def update?
    @update
  end
end
