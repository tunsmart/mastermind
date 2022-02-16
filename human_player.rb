# frozen_string_literal: true

class HumanPlayer
  attr_reader :name, :guess, :make_code, :code_breaker

  include Balls

  def initialize(name, code_breaker)
    @name = name
    @code_breaker = code_breaker
  end

  def code_breaker?
    code_breaker
  end

  def make_code
    select_balls
  end

  def guess
    select_balls
  end
end
