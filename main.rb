# frozen_string_literal: true

require_relative 'balls'
require_relative 'computer'
require_relative 'human_player'
require_relative 'mastermind'

player1 = HumanPlayer.new('Harry', false)
new_game = MasterMind.new(player1)
new_game.play
