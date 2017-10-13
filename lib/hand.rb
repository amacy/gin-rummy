require_relative 'ranks_and_suits'

class Hand
  include RanksAndSuits

  attr_reader :cards, :deadwood_count

  def initialize(cards)
    @deadwood_count = 0
    @cards = cards
    @has_knocked = false
  end

  # shuold be a ! method
  def draw(card)
    @cards << card
  end

  # shuold be a ! method
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

    sets
  end

  def runs
    sorted_cards.inject({}) do |runs, (suit, cards)|
      runs[suit] ||= []
      cards.each_with_index do |card, index|
        next if _already_in_a_run?(runs[suit], card)

        existing_run = _run_to_add_to(runs[suit], card)
        next existing_run << card if existing_run

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

  def find_melds
    melds = []
    melds << runs.values.reject { |run| run.empty? }.flatten
    melds << sets.flatten

    cards_in_melds = melds.flatten

    return melds if cards_in_melds == cards_in_melds.uniq

    dups = cards_in_melds.group_by { |card| card }.select { |_, cards| cards.size > 1 }.map(&:first)

    dups.map do |dup|
      melds_with_dups = melds.select { |meld| meld.include?(dup) }

      melds_by_deadwood = melds_with_dups.inject({}) do |hash, meld|
        hash[_calculate_deadwood(meld)] = meld
        hash
      end

      melds_by_deadwood[melds_by_deadwood.keys.min]
    end
  end

  def _already_in_a_run?(runs, card)
    runs.each { |run| return true if run.include?(card) }

    false
  end

  def _run_to_add_to(runs, card)
    runs.each do |run|
      return run if run.last.rank + 1 == card.rank
    end

    false
  end

  def _calculate_deadwood(melds)
    deadwood_cards = @cards - melds.flatten
    @deadwood_count = deadwood_cards.inject(0) { |sum, card| sum += card.value }
  end

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
