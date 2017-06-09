require_relative 'hand'

class Player
  attr_reader :hand

  def initialize(cards)
    @hand = Hand.new(cards)
    # @score
    # @game_history
  end
end
