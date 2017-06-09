require "spec_helper"

RSpec.describe DiscardPile do
  before do
    @ace_of_spades = Card.new(:ace, :spades)
    @discard_pile = DiscardPile.new(@ace_of_spades)
  end

  it "stores cards in an array" do
    expect(@discard_pile.cards.length).to eq 1
    expect(@discard_pile.cards.first).to be_an_instance_of Card
  end

  it "knows last card discarded" do
    expect(@discard_pile.top).to eq @ace_of_spades
  end
end
