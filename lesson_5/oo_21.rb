require 'yaml'
MESSAGES = YAML.load_file('oo_21.yml')

module Pausable
  def clear
    system 'clear'
  end

  def pause
    sleep(2)
  end

  def prompt(msg_key, data1='', data2='', data3='')
    msg = format(MESSAGES[msg_key], data1: data1, data2: data2, data3: data3)

    puts(msg)
  end

  def puts_pause(msg_key, data1='', data2='', data3='')
    prompt(msg_key, data1, data2, data3)
    pause
  end

  def press_enter_next_screen(msg_key, data1='', data2='', data3='')
    prompt(msg_key, data1, data2, data3)
    puts ''
    puts MESSAGES['press_enter']
    $stdin.gets
    clear
  end
end

class Participant
  include Pausable

  attr_accessor :name, :hand, :points, :other_player

  def initialize(deck, other_player = nil)
    @other_player = other_player
    @name = choose_name
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
    case arr.length
    when 1
      arr.join
    when 2
      "#{arr.first} and #{arr.last}"
    else
      first = arr[0..-2]
      "#{first.join(', ')} and #{arr.last}"
    end
  end

  def display_new_card(deck)
    new_card = deck.determine_card_value(hand.last)
    press_enter_next_screen('new_card', name, hand.last, new_card)
  end

  def reset(deck)
    @hand = deal(deck)
    @points = calculate_point_total(deck, hand)
  end
end

class Player < Participant
  def empty_input(string)
    string.empty? || string.split('').select { |char| char != ' ' } == []
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

  def all_cards
    join_and(hand)
  end

  def display_hand_and_points
    puts_pause('hand_points_player', all_cards, points)
  end
end

class Dealer < Participant
  COMPUTER_NAMES = %w(Dwight_Schrute Ron_Swanson Mr_Robot TechnoBot)

  def choose_name
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

  def visible_points(deck)
    "#{calculate_point_total(deck, hand[1..-1])} visible"
  end

  def display_hand_and_points(deck)
    puts_pause('hand_points_dealer', name, visible_cards, visible_points(deck))
    puts ""
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

class Game
  include Pausable
  BUSTED = 21

  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Dealer.new(deck, player)
  end

  def start
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def display_welcome_message
    clear
    puts_pause('welcome_message')
    puts_pause('intro_message', dealer.name)
    press_enter_next_screen('navigation_rules')
    display_rules if display_rules?
    clear
  end

  def display_rules?
    answer = nil

    loop do
      puts MESSAGES['display_rules?']
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts MESSAGES['invalid_choice']
    end

    answer == 'y' || answer == 'yes'
  end

  def display_rules
    clear
    puts_pause('rules_1', dealer.name)
    puts_pause('rules_2')
    puts_pause('rules_3')
    puts_pause('rules_4', BUSTED)
    press_enter_next_screen('rules_5', dealer.name, BUSTED)
  end

  def main_game
    loop do
      player_turn
      dealer_turn if busted?(player) == false
      game_results
      break unless play_again?
      deck = Deck.new
      reset(player, dealer, deck)
    end
  end

  def display_participants_cards
    player.display_hand_and_points
    dealer.display_hand_and_points(deck)
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
      puts MESSAGES['invalid_choice']
    end

    "stay" if answer == "s" || answer == "stay"
  end

  def player_turn
    loop do
      display_participants_cards
      break if player_hit_or_stay == 'stay'
      clear
      player.hit_play(deck)
      if busted?(player)
        display_busted(player)
        break
      end
    end
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

  def reset(player, dealer, deck)
    player.reset(deck)
    dealer.reset(deck)
  end

  def display_goodbye_message
    puts "Thanks for playing 21!  Goodbye!"
  end
end

Game.new.start
