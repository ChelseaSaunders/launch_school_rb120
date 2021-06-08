=begin
In the previous two exercises, you developed a Card class and a Deck class. You
are now going to use those classes to create and evaluate poker hands. Create a
class, PokerHand, that takes 5 cards from a Deck of Cards and evaluates those
cards as a Poker hand. If you've never played poker before, you may find this
overview of poker hands useful.

You should build your class using the following code skeleton:
=end

# Include Card and Deck classes from the last two exercises.

class Card
  include Comparable

  attr_reader :rank, :suit

  VALUE = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def determine_value(rank)
    (2..10).include?(rank) ? rank : VALUE[rank]
  end

  def <=>(other)
    determine_value(rank) <=> other.determine_value(other.rank)
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :deck

  def initialize
    @deck = reset
  end

  def reset
    deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end

    deck.shuffle
  end

  def draw
    reset if deck.empty?
    deck.pop
  end
end

class PokerHand
  attr_accessor :hand
  HAND_SIZE = 5

  def initialize(deck)
    @hand = generate_hand(deck)
  end

  def generate_hand(deck)
    return deck unless deck.empty?
    hand = []
    HAND_SIZE.times { hand << deck.draw }
    hand
  end

  def print
    puts "#{hand.join(', ')}"
    p hand[0].suit
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    flush? && hand.min == 10
  end

  def straight_flush?
  end

  def four_of_a_kind?
    count = 0
    hand.each do |card|
      current_count = hand.count { |card| card.rank == hand[0].rank }
      count = current_count if current_count > count
    end
    true if count == 4
  end

  def full_house?
  end

  def flush?
    hand.all? { |card| card.suit == hand[0].suit }
  end

  def straight?
  end

  def three_of_a_kind?
    count = 0
    hand.each do |card|
      current_count = hand.count { |card| card.rank == hand[0].rank }
      count = current_count if current_count > count
    end
    true if count == 3
  end

  def two_pair?
  end

  def pair?
    count = 0
    hand.each do |current_card|
      current_count = hand.count { |card| card.rank == current_card.rank }
      count = current_count if current_count > count
    end
    true if count == 2
  end
end

hand = PokerHand.new(Deck.new)

hand.print
puts hand.evaluate

# # Danger danger danger: monkey
# # patching for testing purposes.
# class Array
#   alias_method :draw, :pop
# end

# # Test that we can identify each PokerHand type.
# hand = PokerHand.new([
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ])
# puts hand.evaluate == 'Royal flush'

# hand = PokerHand.new([
#   Card.new(8,       'Clubs'),
#   Card.new(9,       'Clubs'),
#   Card.new('Queen', 'Clubs'),
#   Card.new(10,      'Clubs'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

# hand = PokerHand.new([
#   Card.new(8,      'Clubs'),
#   Card.new(9,      'Diamonds'),
#   Card.new(10,     'Clubs'),
#   Card.new(7,      'Hearts'),
#   Card.new('Jack', 'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new('Queen', 'Clubs'),
#   Card.new('King',  'Diamonds'),
#   Card.new(10,      'Clubs'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

# hand = PokerHand.new([
#   Card.new(9, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(8, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

# hand = PokerHand.new([
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Clubs'),
#   Card.new(5,      'Diamonds'),
#   Card.new(9,      'Spades'),
#   Card.new(3,      'Diamonds')
# ])
# puts hand.evaluate == 'High card'
