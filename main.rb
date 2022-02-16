# frozen_string_literal: true

module Balls

  def balls
    %w[green red blue yellow orange purple].freeze
  end

  def select_balls
    puts "Select four(4) ball colours from this list: #{balls}. You can repeat colours if you want"
    begin
      selection_arr = []
      4.times { selection_arr << gets.chomp.downcase }
      invalid_selection = selection_arr.difference(balls)
      error_message = "You'v made the following invalid selections: #{invalid_selection}. Try again"
      raise error_message if invalid_selection.length.positive?
    rescue => exception
      puts exception
      retry
    else
      selection_arr
    end
  end

end

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
    ["green","green","red","red"]
  end

  def another_guess(returned_result, previous_guess)

    all_possible_codes.each do |code|
      result = Hash.new(0)
      code2=code.clone
      temp_p = previous_guess.clone
      code.each_with_index do |ball,position|
        if previous_guess[position] == ball
            #binding.pry
          result[:black] += 1
          code2[position] = nil
          temp_p[position] = nil
        end
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

class MasterMind
  attr_reader :player
  attr_accessor :code

  include Balls

  def initialize(player)
    @player = player
    @code = player.code_breaker? ? balls.sample(4) : nil
  end

  def play
   if player.code_breaker?
     play_as_code_breaker
   else 
     play_as_code_maker
   end
  end

  def placeholder
    result = Hash.new(0)
      code2=code.clone
      temp_p = previous_guess.clone
      code.each_with_index do |ball,position|
        if previous_guess[position] == ball
          result[:black] += 1
          code2[position] = nil
          temp_p[position] = nil
        end
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
  end

  def play_as_code_breaker
    tries = 12
    result = Hash.new(0)
    temp_code = code.clone
    player_guess = player.guess
    temp_player_guess = player_guess.clone
    while tries.positive?
      player_guess.each_with_index do |ball, position|
        if temp_code[position] == ball
          result[:black] += 1
          temp_player_guess[position] = nil
          temp_code[position] = nil
        end
      end
      temp_player_guess.compact!
      temp_code.compact!
      unless temp_player_guess.empty?
        temp_player_guess.each do |ball|
          if temp_code.any?(ball)
            result[:white] += 1
            temp_code.delete(ball)
          end
        end
      end
      if result[:black] == 4
        puts 'You broke the code. You won'
        break
      else
        puts "Your result is: #{result}. Your selection is: #{player_guess}"
        puts 'Try again'
        temp_code = code.clone
        player_guess = player.guess
        temp_player_guess = player_guess.clone
        result = Hash.new(0)
        tries -= 1
      end
    end
    puts "You'v had 12 unsuccessful tries. You lost!" if tries.zero?
  end

  def play_as_code_maker
    computer = Computer.new
    self.code = player.make_code
    tries = 12
    result = Hash.new(0)
    temp_code = code.clone
    player_guess = computer.first_guess
    temp_player_guess = player_guess.clone
    while tries.positive?
      player_guess.each_with_index do |ball, position|
        if temp_code[position] == ball
          result[:black] += 1
          temp_player_guess[position] = nil
          temp_code[position] = nil
        end
      end
      temp_player_guess.compact!
      temp_code.compact!
      unless temp_player_guess.empty?
        temp_player_guess.each do |ball|
          if temp_code.any?(ball)
            result[:white] += 1
            temp_code.delete(ball)
          end
        end
      end
      tries -= 1
      if result[:black] == 4
        puts "Computer's result is: #{result}. Computer's selection is: #{player_guess}"
        puts "Computer broke your code in #{12 - tries - 1} tries"
        break
      else
        puts "Computer's result is: #{result}. Computer's selection is: #{player_guess}"
        puts "Computer has #{tries} tries left. Retrying in 5secs..."
        temp_code = code.clone
        player_guess = computer.another_guess(result, player_guess)
        temp_player_guess = player_guess.clone
        result = Hash.new(0)
        sleep(5)
      end
    end
    puts "Computer has had 12 unsuccessful tries. You won!" if tries.zero?
  end
end

player1 = HumanPlayer.new('Baba', false)
new_game = MasterMind.new(player1)
new_game.play
