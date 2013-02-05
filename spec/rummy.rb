require 'minitest/autorun'
require_relative '../deck.rb'

describe Card do
  before do
    @card1 = Card.new(A, 'Spades')
    @card2 = Card.new(J, 'Hearts')
    @card3 = Card.new(7, 'Clubs')
  end

  describe "#initialize" do
    it "should have a rank and suit" do
      @card1.rank.must_equal A
      @card1.suit.must_equal 'Spades'
      @card2.rank.must_equal J
      @card2.suit.must_equal 'Hearts'
      @card3.rank.must_equal 7
      @card3.suit.must_equal 'Clubs'
    end
  end

  describe '#calc_value' do
    before do
      @card1.calc_value
      @card2.calc_value
      @card3.calc_value
    end

    it "should calculate the card's value" do
      @card1.value.must_equal 1
      @card2.value.must_equal 10
      @card3.value.must_equal 7
    end
  end
end

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

describe Player do
  before do
    @deck = Deck.new
    @drawn_card = @deck.remove_card
    @player = Player.new(@deck.deal_hand)
  end

  describe '#initialize' do
    it 'should set some instance variables' do
      @player.cards.must_be_instance_of Array
      @player.cards.length.must_equal 10
      @player.score.must_equal 0
      @player.sets.length.must_equal 13
      @player.sets[7].must_equal []
      @player.runs.length.must_equal 4
      @player.runs['Spades'].must_equal []
    end
  end
  
  describe '#draw' do
    before do
      @player.draw(@drawn_card)
    end
    it "should add a card to the player's hand" do
      @player.cards.length.must_equal 11
      @player.cards.last.must_equal @drawn_card
      @player.cards.last.must_be_instance_of Card
    end

    describe '#discard' do
      before do
        @player.discard(10)
      end

      it "should remove a card from the player's hand" do
        @player.cards.length.must_equal 10
        @player.cards.last.wont_equal @drawn_card
        @player.cards.last.must_be_instance_of Card
      end
    end
  end

  describe '#find_sets' do
    before do
      @card1 = Card.new(A, 'Diamonds')
      @card2 = Card.new(A, 'Clubs')
      @card3 = Card.new(A, 'Spades')
      @melds = [@card1, @card2, @card3]
      @player2 = Player.new(@melds)
      @player2.find_sets
    end

    it 'should return an array of sets' do
      @player2.sets[A].must_include @card1
      @player2.sets[A].must_include @card2
      @player2.sets[A].must_include @card3
    end
  end

  describe '#find_runs' do
    before do
      @card4 = Card.new(2, 'Clubs')
      @card5 = Card.new(3, 'Clubs')
      @card6 = Card.new(4, 'Clubs')
      @melds2 = [@card4, @card5, @card6]
      @player3 = Player.new(@melds2)
      @player3.find_runs
    end

    it 'should return an array of runs' do
      @player3.runs['Clubs'].must_include @card4
      @player3.runs['Clubs'].must_include @card5
      @player3.runs['Clubs'].must_include @card6
    end
  end
  #  describe '#deadwood' do
  #  end
  #
  #  describe '#gin' do
  #  end
  #
  #  describe '#knock' do
  #  end
  #
  #  describe '#undercut' do
  #  end
end

describe Game do
  before do
    @game = Game.new
  end

  describe '#initialize' do
    it 'should set some instance variables' do
      @game.player1.must_be_instance_of Player
      @game.player2.must_be_instance_of Player
      @game.deck.must_be_instance_of Deck
      @game.turn.must_equal 0
      @game.whos_turn.must_be_instance_of Player
    end
  end

#  describe '#status' do
#    before do
#      @game.status
#    end
#
#    it 'should put a string containing game info' do
#      @game.status.must_include 
#    end
#  end
#
#  describe '#draw'
#
#  describe '#discard'

  describe '#turn' do
    before do
      @game.new_turn
    end
    
    it 'should iterate the turn number' do
      @game.turn.must_equal 1
    end
  end
end

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
