require 'yaml'
MESSAGES = YAML.load_file('oo_21.yml')

class Participant
  attr_accessor :hand, :points, :visible_cards, :name, :visible_points

  def initialize(deck, other_player = nil)
    @name = get_name(other_player)
    @hand = deal(deck)
    @points = calculate_point_total(deck, hand)
  end

  def deal(deck)
    deck.current_cards.pop(2)
  end

  def hit_add_card(deck)
    hand << deck.current_cards.pop
  end

  def hit_play(deck)
    hit_add_card(deck)
    display_new_card(deck)
    update_points(deck, hand)
    display_hand_and_points
  end

  def aces(deck, total, ace_card)
    if total > 10
      deck.determine_card_value(ace_card)[0]
    else
      deck.determine_card_value(ace_card)[1]
    end
  end

  def calculate_point_total(deck, cards)
    total = 0
    cards.each do |card|
      if card[0..2] != 'Ace'
        total += deck.determine_card_value(card)
      elsif card[0..2] == 'Ace'
        total += aces(deck, total, card)
      end
    end

    total
  end

  def update_points(deck, hand)
    @points = calculate_point_total(deck, hand)
  end

  def join_and(arr)
    string = ''
    case arr.length
    when 1
      string = arr.join
    when 2
      string = arr.first + ' and ' + arr.last
    else
      first = arr[0..-2]
      string = first.join(', ') + ' and ' + arr.last
    end

    string
  end

  def display_new_card(deck)
    puts "#{name} was dealt a #{hand.last} worth #{deck.determine_card_value(hand.last)} points."
  end
end

class Player < Participant
  def empty_input(string)
    string.empty? || string.split('').select { |char| char != ' ' } == []
  end

  def get_name(other_player)
    name = ''
    loop do
      puts MESSAGES['enter_name']
      name = gets.chomp
      break unless empty_input(name)
      puts MESSAGES['no_name_error']
    end

    name
  end

  def display_hand_and_points
    puts "#{name} has #{join_and(hand)} for a total of #{points} points."
  end
end

class Dealer < Participant
  COMPUTER_NAMES = %w(Dwight_Schrute Ron_Swanson Mr_Robot TechnoBot)

  def initialize(deck, other_player)
    super(deck, other_player)
    @visible_points = calculate_visible_points(deck)
  end

  def get_name(other_player)
    @name = nil
    loop do
      @name = COMPUTER_NAMES.sample
      break unless name.downcase == other_player.name.downcase
    end

    name
  end

  def visible_cards
    "an unknown card and #{join_and(hand[1..-1])}"
  end

  def calculate_visible_points(deck)
    "#{calculate_point_total(deck, hand[1..-1])} visible"
  end

  def display_hand_and_points
    puts "#{name} has #{visible_cards}} for a total of #{visible_points} points."
  end
end

class Deck
  SUITS = %w(Hearts Clubs Diamonds Spades)
  FACE_CARDS = %w(1 2 3 4 5 6 7 8 9 Jack Queen King Ace)

  attr_accessor :current_cards
  attr_reader :card_values

  def initialize
    @card_values = generate_card_values_hash(SUITS, FACE_CARDS)
    @current_cards = initialize_deck
  end

  def determine_card_value(card)
    if card.start_with?('Ace')
      [1, 11]
    elsif card.to_i != 0
      card.to_i
    else
      10
    end
  end

  def generate_card_values_hash(suits, face_cards)
    card_values = {}

    suits.each do |suit|
      face_cards.each do |card|
        card_values["#{card} of #{suit}"] = determine_card_value(card)
      end
    end

    card_values
  end

  def initialize_deck
    deck = []
    card_values.each_key { |card| deck << card }
    deck.shuffle
  end
end

#=begin
class Game
  BUSTED = 21

  attr_accessor :deck, :player, :dealer

    def initialize
      @deck = Deck.new
      @player = Player.new(deck)
      @dealer = Dealer.new(deck, player)

  end

  def start
    display_welcome_message
    show_participants_cards
    player_turn
    dealer_turn
    show_result
  end

  private

  def display_welcome_message
    puts "welcome to 21"

  end

  def show_participants_cards
    player.display_hand_and_points
    dealer.display_hand_and_points
  end

  def busted?(participant)
    participant.points > BUSTED
  end

  def display_busted(participant)
    puts "#{participant.name} busted!"
  end

  def player_hit_or_stay
    answer = nil
    loop do
      puts "Would you like to hit (h) or stay (s)?"
      answer = gets.chomp.downcase
      break if %w(h s stay hit).include?(answer)
      puts "Sorry, invalid answer."
    end

    "stay" if answer == "s"|| answer == "stay"
  end

  def player_turn
    loop do
      break if player_hit_or_stay == 'stay'
      player.hit_play(deck)
      if busted?(player)
        display_busted(player)
        break
      end
    end
  end
end

def display_dealer_hit_or_stay


Game.new.start
#=end

# deck = Deck.new

# player = Player.new(deck)
# dealer = Dealer.new(deck, player)

# p player.hand
# p dealer.hand
# player.display_hand_and_points

# dealer.display_hand_and_points
