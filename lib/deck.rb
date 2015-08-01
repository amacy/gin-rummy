require_relative 'ranks_and_suits'
require_relative 'card'

class Deck
  include RanksAndSuits

  attr_reader :cards

  def initialize
    @cards = []
    full
    @cards.shuffle!
  end

  def full
    SUITS.each do |suit|
      RANKS.each_key do |rank|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def remove_card
    card = @cards.sample
    @cards.delete(card)
    card
  end

  def deal_hand
    hand = []
    10.times do
      hand << remove_card
    end
    hand
  end
end
