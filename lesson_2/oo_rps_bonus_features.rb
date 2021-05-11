=begin

Add Lizard and Spock:
This is a variation on the normal Rock Paper Scissors game by adding two more
options - Lizard and Spock. The full explanation and rules are here.
Add a class for each move:
What would happen if we went even further and introduced 5 more classes, one for
each move: Rock, Paper, Scissors, Lizard, and Spock. How would the code change?
Can you make it work? After you're done, can you talk about whether this was a
good design decision? What are the pros/cons?
Keep track of a history of moves:
As long as the user doesn't quit, keep track of a history of moves by both the
human and computer. What data structure will you reach for? Will you use a new
class, or an existing class? What will the display output look like?
Computer personalities:
We have a list of robot names for our Computer class, but other than the name,
there's really nothing different about each of them. It'd be interesting to
explore how to build different personalities for each robot. For example, R2D2
can always choose "rock". Or, "Hal" can have a very high tendency to choose
"scissors", and rarely "rock", but never "paper". You can come up with the rules
or personalities for each robot. How would you approach a feature like this?
=end

class Score
  MAX_SCORE = 2

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

class Move
  attr_reader :value, :type
  VALUES = %w(rock paper scissors lizard spock)

  def initialize(value)
    @value = value
    set_type
  end

  def set_type
    case value
    when "rock"
      @type = Rock.new
    when "paper"
      @type = Paper.new
    when "scissors"
      @type = Scissors.new
    when "lizard"
      @type = Lizard.new
    when "spock"
      @type = Spock.new
    end
  end

  def >(other)
    self.type.win?(other.type)
  end

  def to_s
    value
  end
end

class Rock
  def win?(other)
    true unless other.class == Spock || other.class == Paper
  end
end

class Paper
  def win?(other)
    true unless other.class == Scissors || other.class == Lizard
  end
end

class Scissors
  def win?(other)
    true unless other.class == Spock || other.class == Rock
  end
end

class Lizard
  def win?(other)
    true unless other.class == Scissors || other.class == Rock
  end
end

class Spock
  def win?(other)
    true unless other.class == Paper || other.class == Lizard
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    set_score
  end

  def set_score
    @score = Score.new
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
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Robot', 'Internet Machine', 'Computer'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def pause
    sleep(2)
  end

  def display_welcome_message
    pause
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    pause
    puts "Today you will be playing against #{computer.name}."
    pause
  end

  def display_goodbye_message
    pause
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    pause
    puts "#{computer.name} chose #{computer.move}."
    pause
  end

  def display_round_winner
    pause
    if human.move > computer.move
      puts "#{human.name} won this round!"
    elsif computer.move > human.move
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie! When there is a tie, neither player gains points."
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
    human.score.max_score? || computer.score.max_score?
  end

  # rubocop:disable Layout/LineLength

  def display_human_won_tournament
    puts "Congratulations #{human.name}! you have reached the maximum score of #{human.score}!"
    pause
    puts "You won the tournament!"
  end

  def display_computer_won_tournament
    puts "Sorry, #{human.name}, looks like #{computer.name} reached the maximum score of #{computer.score}."
    pause
    puts "#{computer.name} won the tournament. Better luck next time!"
  end

  def display_no_tournament_winner
    puts "No one has enough points to win the tournament."
    pause
    puts "#{human.name} needs #{human.score.max_score_difference} to win the tournament."
    pause
    puts "#{computer.name} needs #{computer.score.max_score_difference} to win the tournament."
    pause
  end

  # rubocop:enable Layout/LineLength

  def display_tournament_status
    if human.score.max_score?
      display_human_won_tournament
    elsif computer.score.max_score?
      display_computer_won_tournament
    else
      display_no_tournament_winner
    end
  end

  def display_game_status
    display_round_winner
    puts "#{human.name} has #{human.score}."
    pause
    puts "#{computer.name} has #{computer.score}."
    pause
    display_tournament_status
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, invalid answer! Please enter 'y' for 'yes' or 'n' for 'no'."
    end

    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      update_score
      display_game_status
      break if tournament_winner? || (play_again? == false)
    end
    display_goodbye_message
  end
end

RPSGame.new.play
