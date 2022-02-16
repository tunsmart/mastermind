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
    rescue StandardError => e
      puts e
      retry
    else
      selection_arr
    end
  end
end
