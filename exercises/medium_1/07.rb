# Create an object-oriented number guessing class for numbers in the range 1 to
# 100, with a limit of 7 guesses per game. The game should play like this:

class GuessingGame
  attr_accessor :guess, :guesses_left
  attr_reader :number

  def initialize(low_num, high_num)
    @number = determine_number(low_num, high_num)
    @guess = nil
    @guesses_left = determine_number_of_guesses(low_num, high_num)
  end

  def determine_number(low_num, high_num)
    rand(low_num..high_num)
  end

  def determine_number_of_guesses(low_num, high_num)
   size_of_range = (high_num - low_num).to_f
   Math.log2(size_of_range).to_i + 1
  end

  def play
  loop do
    display_guesses_remaining
    player_guess
    decrease_remaining_guesses
    break if guess == number || guesses_left == 0
    display_hint
  end

    display_game_result
  end

  private

  def display_guesses_remaining
    puts "You have #{guesses_left} guesses remaining."
  end

  def player_guess
    loop do
      puts "Enter a number between 1 and 100:"
      @guess = gets.chomp.to_i
      break if (1..100).to_a.include?(guess)
      puts "Invalid guess."
    end

    guess
  end

  def decrease_remaining_guesses
    @guesses_left -= 1
  end

  def display_hint
    if guess < number
      puts "Your guess is too low."
    else
      puts "Your guess is too high."
    end

    puts ''
  end

  def display_game_result
    if guess == number
      puts "That's the number!"
    else
      puts "You have no more guesses.  You lost!"
    end
  end
end

game = GuessingGame.new(3, 4000)
game.play
