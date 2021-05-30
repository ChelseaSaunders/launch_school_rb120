require 'yaml'
MESSAGES = YAML.load_file('oo_tic_tac_toe.yml')

module Pausable
  def clear
    system 'clear'
  end

  def pause
    sleep(2)
  end

  def prompt(msg_key, custom_data='')
    message = format(MESSAGES[msg_key], custom_data: custom_data)

    puts(message)
  end

  def puts_pause(msg_key, custom_data='')
    prompt(msg_key, custom_data)
    pause
  end

  def press_enter_next_screen(msg_key, custom_data='')
    prompt(msg_key, custom_data)
    puts ''
    puts MESSAGES['press_enter']
    $stdin.gets
    clear
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]
  CENTER_SQUARE = 5
  IMMINENT_WIN = 2
  WIN = 3

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  def draw
    puts "     |     |"
    puts " #{@squares[1]}   |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_player_marker(squares, marker)
    squares.collect(&:marker).count(marker)
  end

  def winning_marker
    WINNING_LINES.each do |line|
      first_in_line = @squares[line[0]]
      all_markers_in_line = @squares.values_at(*line)

      next if first_in_line.unmarked?

      if count_player_marker(all_markers_in_line, first_in_line.marker) == WIN
        return first_in_line.marker
      end
    end

    nil
  end

  def find_last_empty_square_in_line(line)
    line.select { |k| @squares[k].marker == Square::INITIAL_MARKER }.first
  end

  def find_imminent_win_square(player_marker)
    imminent_square = nil

    WINNING_LINES.each do |line|
      line_markers = @squares.values_at(*line)

      player_squares = count_player_marker(line_markers, player_marker)
      empty_squares = count_player_marker(line_markers, Square::INITIAL_MARKER)

      if player_squares == IMMINENT_WIN && empty_squares == 1
        imminent_square = find_last_empty_square_in_line(line)
      end
    end

    imminent_square
  end

  def imminent_win?(player_marker)
    return false if find_imminent_win_square(player_marker).nil?
    true
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Score
  attr_accessor :points

  def initialize
    @points = 0
  end

  def add_point
    self.points += 1
  end

  def point_or_points
    points == 1 ? "point" : "points"
  end

  def points_needed
    TTTGame::MAX_POINTS - points
  end

  def to_s
    "#{points} #{point_or_points}"
  end
end

class Player
  include Pausable
  attr_reader :marker, :score, :name

  MARKER = @marker

  def initialize
    clear
    @name = choose_name
    clear
    @score = Score.new
  end
end

class Computer < Player
  COMPUTER_NAMES = %w(HAL Internet_Machine TechnoBot Ron_Swanson Mr_Robot)
  POSSIBLE_MARKERS = ('0'..'z').to_a

  def choose_name
    COMPUTER_NAMES.sample
  end

  def choose_marker(other_marker)
    @marker = nil
    loop do
      @marker = POSSIBLE_MARKERS.sample
      break unless marker.downcase == other_marker.downcase
    end

    marker
  end
end

class Human < Player
  def initialize
    super
    clear
    choose_marker
  end

  def empty_input(string)
    string.empty? || string.split('').select { |char| char != ' '} == []
  end

  def choose_name
    name = ''
    loop do
      puts MESSAGES['enter_name']
      name = gets.chomp
      break unless empty_input(name)
      puts MESSAGES['no_name_error']
    end

    name
  end

  def choose_marker
    @marker = ''

    loop do
      puts MESSAGES['choose_marker']
      @marker = gets.chomp
      break unless empty_input(marker) || marker.length > 1
      puts MESSAGES['invalid_marker']
    end

    marker
  end

  def first_to_move(other_marker)
    first_player = nil
    loop do
      puts MESSAGES['choose_first_player']
      first_player = gets.chomp
      break if first_player == "1" || first_player == "2"
      puts MESSAGES['invalid_choice']
    end

    first_player == "1" ? marker : other_marker
  end
end

class TTTGame
  include Pausable

  attr_accessor :board, :human, :computer, :first_to_move

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    computer.choose_marker(human.marker)
    @first_to_move = human.first_to_move(computer.marker)
    @current_marker = first_to_move
  end

  MAX_POINTS = 5

  def play
    clear
    display_welcome_message
    display_rules
    main_game
    display_goodbye_message
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    clear
    puts_pause('welcome')
    puts ""
    puts_pause('introduce_opponent', computer.name)
    puts_pause('opponent_marker', computer.marker)
    press_enter_next_screen('navigation_rules')
  end

  def display_rules
    puts_pause('match_rules', Board::WIN)
    press_enter_next_screen('tournament_rules', MAX_POINTS)
    press_enter_next_screen('how_to_leave_tournament')
    puts_pause('good_luck')
  end

  def display_goodbye_message
    clear
    puts_pause('goodbye')
  end

  def display_board
    clear
    puts "You are #{human.marker}. #{computer.name} is #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def join_or(unmarked_keys, punctuation = ', ', conjunction = 'or')
    unmarked_keys.map!(&:to_s)
    case unmarked_keys.length
    when 1
      unmarked_keys.last.to_s
    when 2
      unmarked_keys.join(" #{conjunction} ")
    else
      unmarked_keys.last.prepend("#{conjunction} ")
      unmarked_keys.join(punctuation)
    end
  end

  def choose_valid_square
    square = nil
    loop do
      prompt('choose_square', join_or(board.unmarked_keys))
      square = gets.chomp
      break if board.unmarked_keys.include?(square.to_i) && square.length == 1
      puts MESSAGES['invalid_choice']
    end

    square.to_i
  end

  def human_moves
    square = choose_valid_square
    board[square] = human.marker
  end

  def computer_offense_or_defense?(computer_marker, human_marker)
    board.imminent_win?(computer_marker) || board.imminent_win?(human_marker)
  end

  def computer_offense_or_defense(computer_marker, human_marker)
    if board.imminent_win?(computer_marker)
      board[board.find_imminent_win_square(computer_marker)] = computer_marker
    elsif board.imminent_win?(human_marker)
      board[board.find_imminent_win_square(human_marker)] = computer_marker
    else
      false
    end
  end

  def center_square_unmarked?
    board.unmarked_keys.include?(Board::CENTER_SQUARE)
  end

  def computer_mark_center_square(computer_marker)
    board[Board::CENTER_SQUARE] = computer_marker
  end

  def computer_mark_random_square(computer_marker)
    board[board.unmarked_keys.sample] = computer_marker
  end

  def computer_moves
    if computer_offense_or_defense?(computer.marker, human.marker)
      computer_offense_or_defense(computer.marker, human.marker)
    elsif center_square_unmarked?
      computer_mark_center_square(computer.marker)
    else
      computer_mark_random_square(computer.marker)
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def update_score
    human_score = human.score
    computer_score = computer.score

    human_score.add_point if board.winning_marker == human.marker
    computer_score.add_point if board.winning_marker == computer.marker
  end

  def display_score
    puts "#{computer.name} has #{computer.score}."
    press_enter_next_screen('human_score', human.score)
  end

  def display_human_match_winner
    press_enter_next_screen('player_won_match')
  end

  def display_computer_match_winner
    press_enter_next_screen('computer_won_match', computer.name)
  end

  def display_tie_match
    press_enter_next_screen('tie')
  end

  def display_match_winner
    display_board
    case board.winning_marker
    when human.marker
      display_human_match_winner
    when computer.marker
      display_computer_match_winner
    else
      display_tie_match
    end

    display_score
  end

  def tournament_winner?
    human.score.points == MAX_POINTS || computer.score.points == MAX_POINTS
  end

  def display_no_tournament_winner
    human_score = human.score
    computer_score = computer.score
    press_enter_next_screen('no_tournament_winner')
    puts "#{computer.name} needs #{computer_score.points_needed} to win the "\
      "tournament."
    press_enter_next_screen('human_points_needed', human_score.points_needed)
  end

  def display_human_won_tournament
    puts "Congratulations #{human.name}!"
    puts_pause("You won #{MAX_POINTS} matches!")
    press_enter_next_screen("You won the tournament!")
  end

  def display_computer_won_tournament
    prompt('sorry_loss', human.name)
    puts "#{computer.name} was the first to win #{MAX_POINTS} matches."
    press_enter_next_screen('computer_won_tournament', computer.name)
  end

  def display_tournament_status
    if human.score.points == MAX_POINTS
      display_human_won_tournament
    elsif computer.score.points == MAX_POINTS
      display_computer_won_tournament
    else
      display_no_tournament_winner
    end
  end

  def report_score
    update_score
    display_match_winner
  end

  def play_again?
    answer = nil

    loop do
      puts MESSAGES['play_again?']
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts MESSAGES['invalid_choice']
    end

    answer == 'y' || answer == 'yes'
  end

  def reset
    board.reset
    @current_marker = first_to_move
    clear
  end

  def display_play_again_message
    puts MESSAGES['play_again']
    puts ''
  end

  def main_game
    loop do
      display_board
      player_move
      report_score
      display_tournament_status
      break if tournament_winner?
      break unless play_again?
      reset
      display_play_again_message
    end
  end
end

game = TTTGame.new
game.play
