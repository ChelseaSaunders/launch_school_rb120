=begin
Keeping score:
Right now, the game doesn't have very much dramatic flair. It'll be more
interesting if we were playing up to, say, 10 points. Whoever reaches 10 points
first wins. Can you build this functionality? We have a new noun -- a score. Is
that a new class, or a state of an existing class? You can explore both options
and see which one works better.

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
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end

  def rock?
    @value == 'rock'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
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
      puts "Please choose rock, paper, or scissors:"
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
    puts "Welcome to Rock, Paper, Scissors!"
    pause
    puts "Today you will be playing against #{computer.name}."
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    pause
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if human.move > computer.move
      human.score.add_point
      puts "#{human.name} now has #{human.score}!"
      pause
      puts "#{computer.name} has #{computer.score}."
    elsif computer.move > human.move
      computer.score.add_point
      puts "#{computer.name} now has #{computer.score}!"
      pause
      puts "#{human.name} has #{human.score}."
    else
      puts "In a tie, neither player gains points."
      pause
      puts "#{human.name} has #{human.score}."
      pause
      puts "#{computer.name} has #{computer.score}."
    end
  end

  def tournament_winner?
    human.score.max_score? || computer.score.max_score?
  end

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
  end

  def tournament_status
    if human.score.max_score?
      display_human_won_tournament
    elsif computer.score.max_score?
      display_computer_won_tournament
    else
      display_no_tournament_winner
    end
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
    pause
    display_welcome_message
    pause
    loop do
      human.choose
      pause
      computer.choose
      pause
      display_moves
      pause
      display_winner
      pause
      update_score
      pause
      tournament_status
      break if tournament_winner?
      pause
      break unless play_again? == false)
    end
    pause
    display_goodbye_message
  end
end

RPSGame.new.play
