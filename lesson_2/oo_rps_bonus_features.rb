module Pausable
  def pause
    sleep(3)
  end

  def puts_pause(string)
    puts string
    pause
  end
end

class Score
  MAX_SCORE = 4

  attr_accessor :score

  def initialize
    @score = 0
  end

  def add_point
    @score += 1
  end

  def point_or_points
    score == 1 ? 'point' : 'points'
  end

  def max_score?
    score == MAX_SCORE
  end

  def max_score_difference
    MAX_SCORE - score
  end

  def to_s
    "#{@score} #{point_or_points}"
  end
end

class Rock
  include Pausable

  def win?(other)
    true if other.instance_of?(Scissors) || other.instance_of?(Lizard)
  end

  def display_win(other)
    pause
    if other.instance_of?(Scissors)
      puts "Rock smashes scissors!"
    elsif other.instance_of?(Lizard)
      puts "Rock crushes lizard!"
    end
    pause
  end
end

class Paper
  include Pausable

  def win?(other)
    true if other.instance_of?(Rock) || other.instance_of?(Spock)
  end

  def display_win(other)
    pause
    if other.instance_of?(Rock)
      puts "Paper covers rock!"
    elsif other.instance_of?(Spock)
      puts "Paper disproves Spock!"
    end
    pause
  end
end

class Scissors
  include Pausable

  def win?(other)
    true if other.instance_of?(Paper) || other.instance_of?(Lizard)
  end

  def display_win(other)
    pause
    if other.instance_of?(Paper)
      puts "Scissors cut paper!"
    elsif other.instance_of?(Lizard)
      puts "Scissors decapitate lizard!"
    end
    pause
  end
end

class Lizard
  include Pausable

  def win?(other)
    true if other.instance_of?(Paper) || other.instance_of?(Spock)
  end

  def display_win(other)
    pause
    if other.instance_of?(Paper)
      puts "Lizard eats paper!"
    elsif other.instance_of?(Spock)
      puts "Lizard poisons Spock!"
    end
    pause
  end
end

class Spock
  include Pausable

  def win?(other)
    true if other.instance_of?(Rock) || other.instance_of?(Scissors)
  end

  def display_win(other)
    pause
    if other.instance_of?(Rock)
      puts "Spock vaporizes rock!"
    elsif other.instance_of?(Scissors)
      puts "Spock smashes scissors!"
    end
    pause
  end
end

class Move
  attr_reader :value, :type

  VALUES = %w(rock paper scissors lizard spock)
  TYPES = { 'rock' => Rock.new, 'paper' => Paper.new,
            'scissors' => Scissors.new, 'lizard' => Lizard.new,
            'Spock' => Spock.new }

  def initialize(value)
    @value = value
    capitalize_spock
    set_type
  end

  def capitalize_spock
    @value = value.capitalize if value == "spock"
  end

  def set_type
    @type = TYPES[value]
  end

  def >(other)
    type.win?(other.type)
  end

  def display_victory(other)
    type.display_win(other.type)
  end

  def to_s
    value
  end
end

class Player
  include Pausable

  attr_accessor :move, :name, :score, :past_choices

  def initialize
    set_name
    set_score
    @past_choices = []
  end

  def set_score
    @score = Score.new
  end

  def display_past_choices
    puts "#{name}'s past moves are as follows:"
    past_choices.each_with_index do |move, index|
      puts "Round #{index + 1}: #{move}"
    end
    pause
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "Hello! Please enter your name:"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, please enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or Spock:"
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
    @past_choices << move
  end
end

class Characters < Player
  def initialize
    super
    choose
  end
end

class Hal < Characters
  def set_name
    @name = 'Hal'
  end

  def choose
    self.move = Move.new('rock')
  end
end

class Robot < Characters
  def set_name
    @name = 'Robot'
  end

  def choose
    move_selection = nil
    loop do
      move_selection = Move::VALUES.sample
      break if move_selection != 'paper'
    end

    self.move = Move.new(move_selection)
  end
end

class InternetMachine < Characters
  def set_name
    @name = 'Internet Machine'
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Computer < Player
  attr_accessor :character

  CHARACTERS = [InternetMachine.new, Robot.new, Hal.new]

  def initialize
    @character = CHARACTERS.sample
    super
  end

  def set_name
    @name = character.name
  end

  def set_score
    @score = character.score
  end

  def choose
    self.move = character.choose
    past_choices << move
  end
end

class RPSGame
  include Pausable

  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def clear_screen
    system 'clear'
  end

  # rubocop:disable Layout/LineLength

  # This seems an appropriate welcome message and is barely over the line limit;
  # altering it to please rubocop seems unnecessary.

  def display_welcome_message
    clear_screen
    puts_pause("Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!")
    puts_pause("Today you will be playing against #{computer.name}.")
    clear_screen
  end

  # rubocop:enable Layout/LineLength

  def display_goodbye_message
    pause
    clear_screen
    puts_pause("Thanks for playing Rock, Paper, Scissors! Goodbye!")
    clear_screen
  end

  def player_choices
    human.choose
    computer.choose
  end

  def display_moves
    clear_screen
    puts_pause("#{human.name} chose #{human.move}.")
    puts_pause("#{computer.name} chose #{computer.move}.")
    clear_screen
  end

  # rubocop:disable Metrics/MethodLength

  # This method is only one line over the maximimum; I believe it is clear and
  # have not been able to refactor it to shorten it successfully and still get
  # my desired output.

  def display_round_winner
    human_move = human.move
    computer_move = computer.move

    if human_move > computer_move
      human_move.display_victory(computer_move)
      puts_pause("#{human.name} won this round!")
    elsif computer_move > human_move
      computer_move.display_victory(human_move)
      puts_pause("#{computer.name} won this round!")
    else
      puts_pause("It's a tie! When there's a tie, neither player gains points.")
    end
  end

  # rubocop:enable Metrics/MethodLength

  def update_score
    if human.move > computer.move
      human.score.add_point
    elsif computer.move > human.move
      computer.score.add_point
    end
  end

  def tournament_winner?
    human.score.max_score? || computer.score.max_score?
  end

  # rubocop:disable Layout/LineLength

  # These outputs don't occupy too much space on the screen when actually
  # printed, and given that they are string outputs, rather than complicated
  # lines of code, I feel it is ok to disable this cop.
  # I would use a yaml file instead, but I don't know how to do interpollation
  # with a yaml file.

  def display_human_won_tournament
    puts_pause("Congratulations #{human.name}! you have reached the maximum score of #{human.score}!")
    puts_pause("You won the tournament!")
  end

  def display_computer_won_tournament
    puts_pause("Sorry, #{human.name}, looks like #{computer.name} reached the maximum score of #{computer.score}.")
    puts "#{computer.name} won the tournament. Better luck next time!"
  end

  def display_tournament_status?
    answer = nil
    loop do
      puts "Would you like to see the tournament status? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, invalid answer! Type 'y' for 'yes' or 'n' for 'no'."
    end

    clear_screen
    return true if answer == 'y'
    false
  end

  def display_no_tournament_winner
    clear_screen
    puts_pause("No one has enough points to win the tournament.")
    clear_screen
    puts_pause("#{human.name} needs #{human.score.max_score_difference} to win the tournament.")
    puts_pause("#{computer.name} needs #{computer.score.max_score_difference} to win the tournament.")
    clear_screen
  end

  # rubocop:enable Layout/LineLength

  def display_tournament_status
    if human.score.max_score?
      display_human_won_tournament
    elsif computer.score.max_score?
      display_computer_won_tournament
    elsif display_tournament_status?
      display_no_tournament_winner
    end
  end

  def display_game_status
    display_round_winner
    clear_screen
    puts_pause("#{human.name} has #{human.score}.")
    puts_pause("#{computer.name} has #{computer.score}.")
    clear_screen
    display_tournament_status
  end

  def display_past_moves?
    answer = nil
    loop do
      puts "Would you like to view all past moves? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, invalid answer! Type 'y' for 'yes' or 'n' for 'no'."
    end

    clear_screen
    return true if answer == 'y'
    false
  end

  def display_past_moves_both_players
    if display_past_moves?
      human.display_past_choices
      computer.display_past_choices
    end
    clear_screen
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, invalid answer! Type 'y' for 'yes' or 'n' for 'no'."
    end

    clear_screen

    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message
    loop do
      player_choices
      display_moves
      update_score
      display_game_status
      break if tournament_winner? || (play_again? == false)
      display_past_moves_both_players
    end
    display_goodbye_message
  end
end

RPSGame.new.play
