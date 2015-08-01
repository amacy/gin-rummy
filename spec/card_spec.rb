require "minitest/autorun"
require_relative "../lib/card"

describe Card do
  before do
    @ace_of_spades = Card.new(:ace, :spades)
    @jack_of_hearts = Card.new(:jack, :hearts)
    @seven_of_clubs = Card.new(:seven, :clubs)
  end

  it "has a rank, name, value and suit" do
    @ace_of_spades.rank.must_equal 1
    @ace_of_spades.suit.must_equal :spades
    @ace_of_spades.name.must_equal "Ace of Spades"
    @ace_of_spades.value.must_equal 1

    @jack_of_hearts.rank.must_equal 11
    @jack_of_hearts.suit.must_equal :hearts
    @jack_of_hearts.name.must_equal "Jack of Hearts"
    @jack_of_hearts.value.must_equal 10

    @seven_of_clubs.rank.must_equal 7
    @seven_of_clubs.suit.must_equal :clubs
    @seven_of_clubs.name.must_equal "Seven of Clubs"
    @seven_of_clubs.value.must_equal 7
  end
end
