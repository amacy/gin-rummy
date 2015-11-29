require_relative 'ranks_and_suits'
require_relative 'deck'

class Player

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

  def discard(n)
    @cards.delete_at(n)
  end

  def _sorted_cards
    sorted_cards = @cards.sort_by { |card| card.rank }
    sorted_cards.group_by { |card| card.suit }
  end

  def _sets
    sets = []
    RANKS.each do |rank, int|
      matches = @cards.select do |card|
        card.rank == int
      end

      sets << matches if matches.length >= 3
    end
    sets.flatten
  end

  def _runs
    runs = {}
    _sorted_cards.each do |suit, cards|
      runs[suit] ||= []
      cards.each_with_index do |card, index|
        next if runs[suit].include?(card)
        possible_run = _find_run(card, cards, index)
        runs[suit] << possible_run if possible_run.length >= 3
      end
    end
    runs.select { |_, cards| cards.length > 0 }
  end

  def _find_run(current_card, cards, index)
    next_index = index + 1
    next_card = cards[next_index]
    current_run = []
    while next_card && current_card.rank + 1 == next_card.rank do
      current_run << current_card
      next_index += 1
      current_card = next_card
      next_card = cards[next_index]
    end
    current_run
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
