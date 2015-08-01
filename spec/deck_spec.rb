require 'minitest/autorun'
require_relative '../lib/deck.rb'

describe Deck do
  before do
    @deck = Deck.new
  end

  describe '#initialize' do
    it 'should set some instance variables' do
      @deck.cards.must_be_instance_of Array
    end
  end

  describe '#full' do
    it 'should create 52 cards' do
      @deck.cards.length.must_equal 52
      @deck.cards.sample.must_be_instance_of Card
    end
  end

  describe '#deal_hand (& remove_card)' do
    before do
      @hand = @deck.deal_hand
    end

    it 'should select and remove 10 cards from the deck' do
      @hand.length.must_equal 10
      @deck.cards.length.must_equal 42
    end
  end
end
