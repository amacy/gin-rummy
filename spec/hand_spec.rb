require "spec_helper"

RSpec.describe Hand do
  before do
    @deck = Deck.new
    @hand = Hand.new(@deck.deal_hand)
  end

  describe "#draw" do
    before do
      @drawn_card = @deck.remove_card
      @hand.draw(@drawn_card)
    end

    it "should add a card to the hand" do
      expect(@hand.cards.length).to eq 11
      expect(@hand.cards.last).to eq @drawn_card
      expect(@hand.cards.last).to be_an_instance_of Card
    end
  end

  describe "#discard" do
    before do
      @hand.discard(10)
    end

    it "should remove a card from the hand" do
      expect(@hand.cards.length).to eq 10
      expect(@hand.cards).to_not include @drawn_card
    end
  end

  describe "#sorted_cards" do
    it "sorts cards by suit" do
      @hand.sorted_cards.each do |suit, cards_array|
        cards_array.each do |card|
          expect(card.suit).to eq suit
        end
      end
    end

    it "sorts suits by rank" do
      @hand.sorted_cards.each do |suit, cards_array|
        cards_array.each do |card|
          expect(cards_array.first.rank).to be <= card.rank
          expect(cards_array.last.rank).to be >= card.rank
        end
      end
    end
  end

  describe "#sets" do
    it "finds all sets" do
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      five_of_hearts = Card.new(:five, :hearts)
      five_of_spades = Card.new(:five, :spades)
      five_of_clubs = Card.new(:five, :clubs)
      cards = [ace_of_spades, two_of_spades, five_of_hearts, five_of_spades, five_of_clubs]
      hand = Hand.new(cards)

      expect(hand.sets).to eq [five_of_hearts, five_of_spades, five_of_clubs]
    end
  end

  describe "#runs" do
    it "finds runs that contain 3 cards" do
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      three_of_spades = Card.new(:three, :spades)
      five_of_spades = Card.new(:five, :spades)
      five_of_clubs = Card.new(:five, :clubs)
      cards = [ace_of_spades, two_of_spades, three_of_spades, five_of_spades, five_of_clubs]
      hand = Hand.new(cards)

      expected_result = {
        :clubs => [],
        :spades => [[ace_of_spades, two_of_spades, three_of_spades]],
      }
      expect(hand.runs).to eq expected_result
    end

    it "finds runs that contain more than 3 cards" do
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      three_of_spades = Card.new(:three, :spades)
      four_of_spades = Card.new(:four, :spades)
      five_of_spades = Card.new(:five, :spades)
      five_of_clubs = Card.new(:five, :clubs)
      cards = [ace_of_spades, two_of_spades, three_of_spades, four_of_spades, five_of_spades, five_of_clubs]
      hand = Hand.new(cards)

      expected_result = {
        :clubs => [],
        :spades => [[ace_of_spades, two_of_spades, three_of_spades, four_of_spades, five_of_spades]],
      }
      expect(hand.runs).to eq expected_result
    end

    it "finds multiple runs for a single suit" do
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      three_of_spades = Card.new(:three, :spades)
      five_of_spades = Card.new(:five, :spades)
      six_of_spades = Card.new(:six, :spades)
      seven_of_spades = Card.new(:seven, :spades)
      cards = [ace_of_spades, two_of_spades, three_of_spades, five_of_spades, six_of_spades, seven_of_spades]
      hand = Hand.new(cards)

      expected_result = {
        :spades => [
          [ace_of_spades, two_of_spades, three_of_spades],
          [five_of_spades, six_of_spades, seven_of_spades],
        ],
      }
      expect(hand.runs).to eq expected_result
    end
  end
end
