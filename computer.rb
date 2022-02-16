# frozen_string_literal: true

class Computer
  attr_reader :all_possible_codes, :all_possible_codes_copy

  include Balls

  def generate_all_possible_codes
    balls.repeated_permutation(4).to_a
  end

  def initialize
    @all_possible_codes = generate_all_possible_codes
    @all_possible_codes_copy = @all_possible_codes.clone
  end

  def first_guess
    %w[green green red red]
  end

  def another_guess(returned_result, previous_guess)
    all_possible_codes.each do |code|
      result = Hash.new(0)
      code2 = code.clone
      temp_p = previous_guess.clone
      code.each_with_index do |ball, position|
        next unless previous_guess[position] == ball

        # binding.pry
        result[:black] += 1
        code2[position] = nil
        temp_p[position] = nil
      end
      code2.compact!
      temp_p.compact!
      unless code2.empty?
        code2.each do |ball|
          if temp_p.any?(ball)
            result[:white] += 1
            temp_p.delete(ball)
          end
        end
      end
      all_possible_codes_copy.delete(code) unless result == returned_result
    end
    all_possible_codes_copy[0]
  end
end
