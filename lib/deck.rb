require_relative "ranks_and_suits"
require_relative "card"

class Deck
  include RanksAndSuits

  attr_reader :cards

  def initialize
    @cards = _generate_cards
    @cards.shuffle!
  end

  def _generate_cards
    generated_cards = []
    SUITS.each do |suit|
      RANKS.each_key do |rank|
        generated_cards << Card.new(rank, suit)
      end
    end
    generated_cards
  end

  def remove_card
    card = @cards.sample
    @cards.delete(card)
    card
  end

  def deal_hand
    hand = []
    10.times { hand << remove_card }
    hand
  end
end
