require 'minitest/autorun'
require_relative '../lib/card.rb'

describe Card do
  before do
    @card1 = Card.new(:ace, :spades)
    @card2 = Card.new(:jack, :hearts)
    @card3 = Card.new(:seven, :clubs)
  end

  describe "#initialize" do
    it "should have a rank and suit" do
      @card1.rank.must_equal 1
      @card1.suit.must_equal :spades
      @card1.name.must_equal 'Ace of Spades'
      @card2.rank.must_equal 11
      @card2.suit.must_equal :hearts
      @card2.name.must_equal 'Jack of Hearts'
      @card3.rank.must_equal 7
      @card3.suit.must_equal :clubs
      @card3.name.must_equal '7 of Clubs'
      @card1.value.must_equal 1
      @card2.value.must_equal 10
      @card3.value.must_equal 7
    end
  end
end
