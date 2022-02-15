class HumanPlayer
    attr_reader :name, :first_guess, :make_new_guess

    def initialize(name, first_guess)
        @name = name
        @first_guess = first_guess
    end

    def make_new_guess
        new_guess_arr = []
        4.times{new_guess_arr << gets.chomp.downcase}
        new_guess = new_guess_arr
        new_guess
    end
end

class MasterMind
    attr_reader :player, :code

    BALLS = ["green", "red", "blue", "yellow", "orange", "purple"]

    def initialize(player)
        @player = player
        @code = BALLS.sample(4)
    end

    def play
        tries = 12
        result = []
        player_guess = player.first_guess
        while tries > 0
            player_guess.each_with_index do |ball, position|
                if code[position] == ball
                    result << "black"
                elsif code.any?(ball)
                    result << "white"
                else
                    result << ""
                end
            end
           if result.all?("black")
               puts "You broke the code. You won"
               break
           else 
               puts result
               puts "Try again"
               player_guess = player.make_new_guess
               result = []
               tries -= 1
           end
        end
        puts "You lost that one" if tries == 0
    end
end

player1 = HumanPlayer.new("Baba", ["blue", "yellow", "red", "purple"])
new_game = MasterMind.new(player1)
new_game.play