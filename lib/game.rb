require_relative "deck"
require_relative "discard_pile"
require_relative "player"
require_relative "turn"

class Game

  def initialize
    @deck = Deck.new
    @player1 = Player.new(@deck.deal_hand)
    @player2 = Player.new(@deck.deal_hand)
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @turn_count = 0
    players = []
    players << @player1 << @player2
    @current_turn = Turn.new(players.sample, @discard_pile, @deck)
  end

  def play
    while !_finished? do
      @current_turn = Turn.new(_next_player, @discard_pile, @deck).player
    end
  end

  def _current_player
    @current_turn.player
  end

  def _finished?
    _current_player.knocked? ||
      _current_player.gin? ||
      @deck.empty?
  end

  def _next_player
    [@player1, @player2].reject do |player|
      _current_player == player
    end.first
  end

  def final_score
    # implement me
  end
end
