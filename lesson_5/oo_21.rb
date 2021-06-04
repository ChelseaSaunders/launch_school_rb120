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
    prompt('press_enter')
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

  def add_card(deck)
    hand << deck.current_cards.pop
  end

  def hit_play(deck)
    clear
    puts_pause('hit')
    clear
    add_card(deck)
    update_points(deck, hand)
    display_new_card
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

  def display_new_card
    press_enter_next_screen('new_card', name, hand.last, points)
  end

  def all_cards
    join_and(hand)
  end

  def display_hand_and_points
    puts_pause('hand_points', name, all_cards, points)
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
    clear
    name = ''
    loop do
      prompt('enter_name')
      name = gets.chomp
      break unless empty_input(name)
      prompt('no_name_error')
    end

    name
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

  def display_visible_hand_and_points(deck)
    puts_pause('hand_points_visible', name, visible_cards, visible_points(deck))
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
  DEALER_HIT_MAX = 17

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
    puts_pause('welcome_message', player.name)
    puts ''
    puts_pause('intro_message', dealer.name)
    puts ''
    press_enter_next_screen('navigation_rules')
    display_rules if display_rules?
    clear
  end

  def display_rules?
    answer = nil

    loop do
      prompt('display_rules?')
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      prompt('invalid_choice')
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
      #game_results
      break unless play_again?
      deck = Deck.new
      reset(player, dealer, deck)
    end
  end

  def display_participants_cards_player_turn
    player.display_hand_and_points
    dealer.display_visible_hand_and_points(deck)
  end

  def display_participants_cards_dealer_turn
    player.display_hand_and_points
    dealer.display_hand_and_points
  end

  def display_busted(participant)
    press_enter_next_screen('busted', participant.name)
  end

  def busted?(participant)
    participant.points > BUSTED
  end

  def player_stay?
    answer = nil

    loop do
      prompt('hit_or_stay?')
      answer = gets.chomp.downcase
      break if %w(h s stay hit).include?(answer)
      prompt('invalid_choice')
    end

    display_player_stay if answer == "s" || answer == "stay"
    answer == "s" || answer == "stay"
  end

  def display_player_stay
    clear
    press_enter_next_screen('player_stay')
  end

  def display_current_turn(participant)
    puts_pause('current_turn', participant.name)
    puts ''
  end

  def player_turn
    loop do
      display_current_turn(player)
      display_participants_cards_player_turn
      break if player_stay?
      player.hit_play(deck)
      if busted?(player)
        display_busted(player)
        break
      end
    end
  end

  def dealer_stay?
    if dealer.points < DEALER_HIT_MAX
      display_dealer_stay
      return true
    end

    false
  end

  def display_dealer_stay
    press_enter_next_screen('dealer_stay', dealer.name)
  end

  def prompt_to_display_dealer_move
    puts ''
    press_enter_next_screen('prompt_for_dealer_move', dealer.name)
  end

  def dealer_turn
    loop do
      display_current_turn(dealer)
      display_participants_cards_dealer_turn
      prompt_to_display_dealer_move
      break if dealer_stay?
      dealer.hit_play(deck)
      if busted?(dealer)
        display_busted(dealer)
        break
      end
    end
  end

  def play_again?
    answer = nil

    loop do
      prompt('play_again?')
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      prompt('invalid_choice')
    end

    answer == 'y' || answer == 'yes'
  end

  def reset(player, dealer, deck)
    clear
    player.reset(deck)
    dealer.reset(deck)
  end

  def display_goodbye_message
    puts_pause('goodbye')
    clear
  end
end

Game.new.start
