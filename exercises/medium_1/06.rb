# Create an object-oriented number guessing class for numbers in the range 1 to
# 100, with a limit of 7 guesses per game. The game should play like this:

class GuessingGame
  attr_accessor :guess, :guesses_left
  attr_reader :number

  TOTAL_GUESSES = 7
  NUMBER_RANGE = (1..100)

  def initialize
    @number = rand(NUMBER_RANGE)
    @guess = nil
    @guesses_left = TOTAL_GUESSES
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

game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!
