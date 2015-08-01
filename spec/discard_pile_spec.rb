require 'minitest/autorun'
require_relative '../lib/discard_pile'
require_relative '../lib/deck'

describe DiscardPile do
  before do
    @deck = Deck.new
    @discard = @deck.remove_card
    @discard_pile = DiscardPile.new(@discard)
  end

  describe '#initialize' do
    it 'should set some instance variables' do
      @discard_pile.cards.length.must_equal 1
      @discard_pile.cards[0].must_be_instance_of Card
      @deck.cards.length.must_equal 51
    end
  end

  describe '#top' do
    it 'should be the last card discarded' do
      @discard_pile.top.must_equal @discard
    end
  end
end
