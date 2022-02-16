# frozen_string_literal: true

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

  def play_round(result, player_guess, code)
    temp_code = code.clone
    temp_player_guess = player_guess.clone
    player_guess.each_with_index do |ball, position|
      next unless temp_code[position] == ball

      result[:black] += 1
      temp_player_guess[position] = nil
      temp_code[position] = nil
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
    result
  end

  def play_as_code_breaker
    tries = 12
    result = Hash.new(0)
    player_guess = player.guess
    while tries.positive?
      result = play_round(result, player_guess, code)
      if result[:black] == 4
        puts 'You broke the code. You won'
        break
      else
        puts "Your result is: #{result}. Your selection is: #{player_guess}"
        puts 'Try again'
        player_guess = player.guess
        result = Hash.new(0)
        tries -= 1
      end
    end
    puts "You'v had 12 unsuccessful tries. You lost!" if tries.zero?
  end

  def play_as_code_maker
    tries = 12
    computer = Computer.new
    self.code = player.make_code
    result = Hash.new(0)
    player_guess = computer.first_guess
    while tries.positive?
      result = play_round(result, player_guess, code)
      tries -= 1
      puts "Computer's result is: #{result}. Computer's selection is: #{player_guess}"
      if result[:black] == 4
        puts "Computer broke your code in #{12 - tries} tries"
        break
      else
        puts "Computer has #{tries} tries left. Retrying in 5secs..."
        temp_code = code.clone
        player_guess = computer.another_guess(result, player_guess)
        temp_player_guess = player_guess.clone
        result = Hash.new(0)
        sleep(5)
      end
    end
    puts 'Computer has had 12 unsuccessful tries. You won!' if tries.zero?
  end
end
