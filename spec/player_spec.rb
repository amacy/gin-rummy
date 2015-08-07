require "pry"
require "minitest/autorun"
require_relative "../lib/player"

describe Player do
  before do
    @deck = Deck.new
    @player = Player.new(@deck.deal_hand)
  end

  describe "#draw" do
    before do
      @drawn_card = @deck.remove_card
      @player.draw(@drawn_card)
    end

    it "should add a card to the player's hand" do
      @player.cards.length.must_equal 11
      @player.cards.last.must_equal @drawn_card
      @player.cards.last.must_be_instance_of Card
    end

  end

  describe "#discard" do
    before do
      @player.discard(10)
    end

    it "should remove a card from the player's hand" do
      @player.cards.length.must_equal 10
      @player.cards.wont_include @drawn_card
    end
  end

  describe "#_sorted_cards" do
    it "sorts cards by suit" do
      @player._sorted_cards.each do |suit, cards_array|
        cards_array.each do |card|
          card.suit.must_equal suit
        end
      end
    end

    it "sorts suits by rank" do
      @player._sorted_cards.each do |suit, cards_array|
        cards_array.each do |card|
          cards_array.first.rank.must_be :<=, card.rank
          cards_array.last.rank.must_be :>=, card.rank
        end
      end
    end
  end

  describe "#_sets" do
    it "finds all sets" do
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      five_of_hearts = Card.new(:five, :hearts)
      five_of_spades = Card.new(:five, :spades)
      five_of_clubs = Card.new(:five, :clubs)
      cards = [ace_of_spades, two_of_spades, five_of_hearts, five_of_spades, five_of_clubs]
      player = Player.new(cards)

      player._sets.must_equal [five_of_hearts, five_of_spades, five_of_clubs]
    end
  end

  describe "#_runs" do
    it "finds all runs" do
      skip
      ace_of_spades = Card.new(:ace, :spades)
      two_of_spades = Card.new(:two, :spades)
      three_of_spades = Card.new(:three, :spades)
      five_of_spades = Card.new(:five, :spades)
      five_of_clubs = Card.new(:five, :clubs)
      cards = [ace_of_spades, two_of_spades, three_of_spades, five_of_spades, five_of_clubs]
      player = Player.new(cards)

      player._sets.must_equal [ace_of_spades, two_of_spades, three_of_spades]
    end
  end
end
