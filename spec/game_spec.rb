require 'minitest/autorun'
require_relative '../lib/game.rb'

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
      @game.knock.must_equal false
    end

    describe '#play_turn' do
      before do
        @last_player = @game.whos_turn
        @game.play_turn
      end

      it 'should iterate the turn number' do
        @game.turn.must_equal 1
      end

      describe '#next_turn' do
        before do
          @game.next_turn
        end

        it 'should change the value of @whos_turn' do
          @last_player.wont_equal @game.whos_turn
        end
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

  end
end
