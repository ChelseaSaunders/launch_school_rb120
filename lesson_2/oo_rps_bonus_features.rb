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

module Clearable
  def clear_screen
    system 'clear'
  end
end

module CharacterSelectable
  def select_character
    [InternetMachine.new, Robot.new, Hal.new].sample
  end
end

class Score
  MAX = 5

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

  def max?
    score == MAX
  end

  def max_difference
    MAX - score
  end

  def to_s
    "#{@score} #{point_or_points}"
  end
end

# Because of the circular logic that occurs when I attempt to invoke a new
# instance of a subclass in its superclass (if the subclasses occur earlier in
# the code, they do not recognize the superclass; if the superclass occurs
# earlier it the code, it does not recognize the subclasses), I opted not to
# make each move a subclass of Move.  However I do agree that they seem to be
# objects of a similar type and making them sub-classes of the same superclass
# makes sense and might be useful were this game to be built out more. For now
# it is a bit silly, since the only inhereted attribute is the attr_reader, but
# groiping like this does add logical consistency that I like.  I did implement
# the wins_against hash and corresponding method changes in the Move class,
# which does DRY up the code.

class MoveTypes
  attr_reader :wins_against
end

class Rock < MoveTypes
  def initialize
    super
    @wins_against = { 'scissors' => 'smashes', 'lizard' => 'crushes' }
  end
end

class Paper < MoveTypes
  def initialize
    super
    @wins_against = { 'rock' => 'covers', 'Spock' => 'disproves' }
  end
end

class Scissors < MoveTypes
  def initialize
    super
    @wins_against = { 'paper' => 'cut', 'lizard' => 'decapitate' }
  end
end

class Lizard < MoveTypes
  def initialize
    super
    @wins_against = { 'paper' => 'eats', 'Spock' => 'poisons' }
  end
end

class Spock < MoveTypes
  def initialize
    super
    @wins_against = { 'scissors' => 'smashes', 'rock' => 'vaporizes' }
  end
end

class Move
  include Pausable

  attr_reader :value, :type, :wins_against

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

  # rubocop:disable Layout/LineLength

  # These outputs don't occupy too much space on the screen when actually
  # printed, and given that they are string outputs, rather than complicated
  # lines of code, I feel it is ok to disable this cop.
  # I would use a yaml file instead, but I don't know how to do interpollation
  # with a yaml file.

  def display_victory(other)
    pause
    if type.wins_against.include?(other.value)
      puts "#{value.capitalize} #{type.wins_against[other.value]} #{other.value}!"
    end
    pause
  end

  # rubocop:enable Layout/LineLength

  def >(other)
    type.wins_against.include?(other.value)
  end

  def to_s
    value
  end
end

class Player
  include Pausable
  include Clearable

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
  CHOICE_ABBREVIATIONS = { 'r' => 'rock', 'p' => 'paper', 'sc' => 'scissors',
                           'l' => 'lizard', 'sp' => 'spock' }
  def set_name
    n = ''
    loop do
      clear_screen
      puts MESSAGES['enter_name']
      n = gets.chomp
      break unless n.empty?
      puts_pause(MESSAGES['invalid_name'])
    end
    self.name = n
  end

  def reassign_abbreviations?(answer)
    CHOICE_ABBREVIATIONS.key?(answer)
  end

  def choose
    choice = nil
    loop do
      puts MESSAGES['choose_character']
      choice = gets.chomp.downcase
      choice = CHOICE_ABBREVIATIONS[choice] if reassign_abbreviations?(choice)
      break if Move::VALUES.include?(choice)
      puts_pause(MESSAGES['invalid_character_choice'])
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
  include Clearable
  include CharacterSelectable

  attr_reader :human, :computer, :round_winner, :round_loser

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

  private

  def initialize
    @human = Human.new
    @computer = select_character
  end

  def display_welcome_message
    clear_screen
    puts_pause("Hi #{human.name}!")
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

  def determine_round_winner
    if human.move > computer.move
      @round_winner = human
      @round_loser = computer
    elsif computer.move > human.move
      @round_winner = computer
      @round_loser = human
    else
      @round_winner = 'tie'
    end
  end

  def display_round_winner
    if round_winner == 'tie'
      puts_enter(MESSAGES['tie_game'])
    else
      @round_winner.move.display_victory(@round_loser.move)
      puts_enter("#{@round_winner.name} won this round!")
    end
  end

  def update_score
    if human.move > computer.move
      human.score.add_point
    elsif computer.move > human.move
      computer.score.add_point
    end
  end

  def tournament_winner?
    human.score.max? || computer.score.max?
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
    answer.downcase == 'y'
  end

  def display_no_tournament_winner
    clear_screen
    puts_pause(MESSAGES['no_tournament_winner'])
    puts_pause("#{human.name} needs #{human.score.max_difference} to win the tournament.")
    puts_enter("#{computer.name} needs #{computer.score.max_difference} to win the tournament.")
    clear_screen
  end

  # rubocop:enable Layout/LineLength

  def display_tournament_status
    if human.score.max?
      display_human_won_tournament
    elsif computer.score.max?
      display_computer_won_tournament
    elsif display_tournament_status?
      display_no_tournament_winner
    end
  end

  def display_game_status
    determine_round_winner
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
    answer.downcase == 'y'
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
    answer.downcase == 'y'
  end
end

RPSGame.new.play
