require_relative "ranks_and_suits"

class Card
  include RanksAndSuits

  attr_reader :rank, :suit, :value, :name

  def initialize(rank, suit)
    @rank = RANKS[rank]
    @suit = suit
    @name = "#{rank.capitalize} of #{@suit.capitalize}"
    @value =  [@rank, 10].min
  end
end
