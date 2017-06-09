require_relative 'ranks_and_suits'

class Hand
  include RanksAndSuits

  attr_reader :cards, :deadwood_count

  def initialize(cards)
    @deadwood_count = 0
    @cards = cards
    @has_knocked = false
  end

  def draw(card)
    @cards << card
  end

  def discard(index)
    @cards.delete_at(index)
  end

  # should be renamed "cards_by_suit"
  def sorted_cards
    sorted_cards = @cards.sort_by { |card| card.rank }
    sorted_cards.group_by { |card| card.suit }
  end

  def sets
    sets = []
    RANKS.each do |rank, int|
      matches = @cards.select do |card|
        card.rank == int
      end

      sets << matches if matches.length >= 3
    end
    sets.flatten
  end

  def runs
    sorted_cards.inject({}) do |runs, (suit, cards)|
      runs[suit] ||= []
      cards.each_with_index do |card, index|
        next_card_1 = cards[index + 1]
        next_card_2 = cards[index + 2]
        break if [next_card_1, next_card_2].include?(nil)
        if next_card_1.rank == card.rank + 1
          if next_card_2.rank == card.rank + 2
            runs[suit] << [card, next_card_1, next_card_2]
          end
        end
      end
      runs
    end
  end

#  def find_melds
#    add_cards = Proc.new { |card| @melds << card unless @melds.include?(card) }
#    @runs.each(&add_cards)
#    @sets.each(&add_cards)
#  end

  def find_cards_in_2_melds
    # figure this out
  end

#  def calc_deadwood
#    @cards.each do |card|
#      @deadwood_cards << card unless @melds.include?(card)
#    end
#
#    @deadwood_cards.each { |card| @deadwood_count += card.value }
#  end

  def gin?
    @deadwood_count == 0
  end

  def can_knock?
    @deadwood_count <= 10
  end

  def knock!
    @has_knocked = true
  end

  def knocked?
    @has_knocked
  end
end
