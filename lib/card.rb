require_relative 'ranks_and_suits'

class Card
  include RanksAndSuits

  attr_reader :rank, :suit, :value, :name

  def initialize(rank, suit)
    @rank, @suit = RANKS[rank], suit
    def name
      if @rank == 1 || @rank > 10
        @name = "#{RANKS.invert[@rank].capitalize} of #{@suit.capitalize}"
      else
        @name = "#{@rank} of #{@suit.capitalize}"
      end
    end
    def calc_value
      if @rank > 10
        @value = 10
      elsif @rank == 1
        @value = 1
      else
        @value = @rank
      end
    end
    name
    calc_value
  end
end
