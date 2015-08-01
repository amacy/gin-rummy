require "minitest/autorun"
require_relative "../lib/discard_pile"

describe DiscardPile do
  before do
    @ace_of_spades = Card.new(:ace, :spades)
    @discard_pile = DiscardPile.new(@ace_of_spades)
  end

  it "stores cards in an array" do
    @discard_pile.cards.length.must_equal 1
    @discard_pile.cards.first.must_be_instance_of Card
  end

  it "knows last card discarded" do
    @discard_pile.top.must_equal @ace_of_spades
  end
end
