class DiscardPile
  attr_reader :cards

  def initialize(card)
    @cards = [card]
  end

  def top
    @cards.last
  end
end
