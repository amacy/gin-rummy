require "spec_helper"

RSpec.describe Card do
  before do
    @ace_of_spades = Card.new(:ace, :spades)
    @jack_of_hearts = Card.new(:jack, :hearts)
    @seven_of_clubs = Card.new(:seven, :clubs)
  end

  it "has a rank, name, value and suit" do
    expect(@ace_of_spades.rank).to eq 1
    expect(@ace_of_spades.suit).to eq :spades
    expect(@ace_of_spades.name).to eq "Ace of Spades"
    expect(@ace_of_spades.value).to eq 1

    expect(@jack_of_hearts.rank).to eq 11
    expect(@jack_of_hearts.suit).to eq :hearts
    expect(@jack_of_hearts.name).to eq "Jack of Hearts"
    expect(@jack_of_hearts.value).to eq 10

    expect(@seven_of_clubs.rank).to eq 7
    expect(@seven_of_clubs.suit).to eq :clubs
    expect(@seven_of_clubs.name).to eq "Seven of Clubs"
    expect(@seven_of_clubs.value).to eq 7
  end
end
