require_relative "deck"
require_relative "player"
require_relative "discard_pile"
require_relative "hand"
require_relative "turn"

class Game
  def initialize
    @deck = Deck.new
    @players = [Player.new(@deck.deal_hand), Player.new(@deck.deal_hand)]
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @turn_count = 0
    @hands = @players.map(&:hand)
    @current_turn = Turn.new(@hands.sample, @discard_pile, @deck)
  end

  def play
    while !_finished? do
      @current_turn = Turn.new(_next_hand, @discard_pile, @deck).hand
    end
  end

  def _current_hand
    @current_turn.hand
  end

  def _finished?
    _current_hand.knocked? || _current_hand.gin? || @deck.empty?
  end

  def _next_hand
    @hands.reject do |hand|
      _current_hand == hand
    end.first
  end

  def final_score
    # implement me
  end
end
