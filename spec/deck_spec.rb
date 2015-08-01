require "minitest/autorun"
require_relative "../lib/deck"

describe Deck do
  before do
    @deck = Deck.new
  end

  describe "#_generate_cards" do
    it "creates 52 cards" do
      @deck.cards.length.must_equal 52
      @deck.cards.sample.must_be_instance_of Card
    end
  end

  describe "#remove_card" do
    it "removes a card from the deck and returns that card" do
      card = @deck.remove_card

      @deck.cards.length.must_equal 51
      card.must_be_instance_of Card
    end
  end

  describe "#deal_hand" do
    before do
      @hand = @deck.deal_hand
    end

    it "selects and remove 10 cards from the deck and returns the created hand" do
      @hand.length.must_equal 10
      @hand.first.must_be_instance_of Card
      @deck.cards.length.must_equal 42
    end
  end
end
