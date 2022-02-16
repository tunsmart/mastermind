require 'pry-byebug'
$all_possible_codes = [1, 2, 3, 4].repeated_permutation(3).to_a
$all_possible_codes_copy = $all_possible_codes.clone
p $all_possible_codes_copy.length

def first_guess
  [1, 2, 3]
end

previous_guess = first_guess

returned_result = { black: 1, white: 1 }

def another_guess(returned_result, previous_guess)
  $all_possible_codes.each do |code|
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
    p result
    $all_possible_codes_copy.delete(code) unless result == returned_result
  end
  p $all_possible_codes_copy.length
end

another_guess(returned_result, previous_guess)
