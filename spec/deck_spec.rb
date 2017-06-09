require "spec_helper"

RSpec.describe Deck do
  before do
    @deck = Deck.new
  end

  describe "#_generate_cards" do
    it "creates 52 cards" do
      expect(@deck.cards.length).to eq 52
      expect(@deck.cards.sample).to be_an_instance_of Card
    end
  end

  describe "#remove_card" do
    it "removes a card from the deck and returns that card" do
      card = @deck.remove_card

      expect(@deck.cards.length).to eq 51
      expect(card).to be_an_instance_of Card
    end
  end

  describe "#deal_hand" do
    before do
      @hand = @deck.deal_hand
    end

    it "selects and remove 10 cards from the deck and returns the created hand" do
      expect(@hand.length).to eq 10
      expect(@hand.first).to be_an_instance_of Card
      expect(@deck.cards.length).to eq 42
    end
  end
end
