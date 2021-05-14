require 'yaml'
MESSAGES = YAML.load_file('oo_rps_bonus_features_messages.yml')

module Pausable
  def pause
    sleep(2)
  end

  def puts_pause(string)
    puts string
    pause
  end

  def press_enter_next_screen
    puts ''
    puts MESSAGES['press_enter']
    $stdin.gets
  end

  def puts_enter(string)
    puts string
    press_enter_next_screen
  end
end

module CharacterSelectable
  def select_character
    [InternetMachine.new, Robot.new, Hal.new].sample
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

class Computer < Player
  def choose
    past_choices << move
  end
end

class Hal < Computer
  def set_name
    @name = 'Hal'
  end

  def choose
    self.move = Move.new('rock')
    super
  end
end

class Robot < Computer
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
    super
  end
end

class InternetMachine < Computer
  def set_name
    @name = 'Internet Machine'
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    super
  end
end

class RPSGame
  include Pausable
  include CharacterSelectable

  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = select_character
  end

  def clear_screen
    system 'clear'
  end

  def display_welcome_message
    clear_screen
    puts_pause("Hello #{human.name}!")
    puts_pause(MESSAGES['welcome'])
    puts_pause("Today you will be playing against #{computer.name}.")
    puts_enter(MESSAGES['navigation_rules'])
    clear_screen
    puts_pause(MESSAGES['tournament_rules'])
    puts_enter(MESSAGES['tournament_rules_2'])
    clear_screen
  end

  def display_goodbye_message
    clear_screen
    puts_pause(MESSAGES['goodbye'])
    clear_screen
  end

  def player_choices
    human.choose
    computer.choose
  end

  def display_moves
    clear_screen
    puts_pause("#{human.name} chose #{human.move}.")
    puts_enter("#{computer.name} chose #{computer.move}.")
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
      puts_enter("#{human.name} won this round!")
    elsif computer_move > human_move
      computer_move.display_victory(human_move)
      puts_enter("#{computer.name} won this round!")
    else
      puts_enter(MESSAGES['tie_game'])
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
    puts_enter(MESSAGES['human_won_tournament'])
  end

  def display_computer_won_tournament
    puts_pause("Sorry, #{human.name}, looks like #{computer.name} reached the maximum score of #{computer.score}.")
    puts_enter("#{computer.name} won the tournament. Better luck next time!")
  end

  def display_tournament_status?
    answer = nil
    loop do
      puts MESSAGES['view_tournament_status']
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts MESSAGES['invalid_answer']
    end

    clear_screen
    return true if answer.downcase == 'y'
    false
  end

  def display_no_tournament_winner
    clear_screen
    puts_pause(MESSAGES['no_tournament_winner'])
    puts_pause("#{human.name} needs #{human.score.max_score_difference} to win the tournament.")
    puts_enter("#{computer.name} needs #{computer.score.max_score_difference} to win the tournament.")
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
    puts_enter("#{computer.name} has #{computer.score}.")
    clear_screen
    display_tournament_status
  end

  def display_past_moves?
    answer = nil
    loop do
      puts MESSAGES['view_past_moves']
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts MESSAGES['invalid_answer']
    end

    clear_screen
    return true if answer.downcase == 'y'
    false
  end

  def display_past_moves_both_players
    if display_past_moves?
      human.display_past_choices
      computer.display_past_choices
      press_enter_next_screen
    end
    clear_screen
  end

  def play_again?
    answer = nil
    loop do
      puts MESSAGES['play_again']
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts MESSAGES['invalid_answer']
    end

    clear_screen

    return true if answer.downcase == 'y'
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
