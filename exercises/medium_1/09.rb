=begin
Using the Card class from the previous exercise, create a Deck class that
contains all of the standard 52 playing cards.

=end

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
    @deck = get_deck
  end

  def get_deck
    deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end

    deck.shuffle
  end

  def reset
    @deck = get_deck
  end

  def draw
    reset if deck.empty?
    deck.pop
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
