require_relative 'ranks_and_suits'
require_relative 'deck'

class Player

  include RanksAndSuits

  attr_reader :cards, :score, :sets, :runs, :melds, :spades, :diamonds,
    :clubs, :hearts, :ace, :two, :three, :four, :five, :six, :seven,
    :eight, :nine, :ten, :jack, :queen, :king, :deadwood_cards, :deadwood_count

  def initialize(cards)
    @cards, @melds, @runs, @sets, @deadwood_cards = [], [], [], [], []
    @score, @deadwood_count = 0, 0
    cards.each { |card| @cards << card }
    set_vars = Proc.new { |v| instance_variable_set("@#{v}", Array.new) }
    RANKS.each_key(&set_vars)
    SUITS.each(&set_vars)
    @has_knocked = false
  end

  def draw(card)
    @cards << card
  end

  def discard(n)
    @cards.delete_at(n)
  end

  def find_sets # also sorts by rank
    RANKS.each do |rank, int|
      matches = []
      @cards.each do |card|
        matches << card if card.rank == int
      end
      if matches.length >= 3
        instance_variable_set("@#{rank}", matches)
        instance_variable_set(:@sets, matches)
      end
    end
  end

  def sort_hand
    @cards.sort_by! { |card| card.rank }
  end

  def sort_by_suit
    SUITS.each do |suit|
      matches = []
      @cards.each do |card|
        matches << card if card.suit == suit
      end
      instance_variable_set("@#{suit}", matches)
    end
  end

  def find_runs
    suits = [@clubs, @diamonds, @hearts, @spades]
    suits.each do |suit|
      suit.each do |card1|
        suit.each do |card2|
          suit.each do |card3|
            c1, c2, c3 = card1.rank, card2.rank, card3.rank
            unless @runs.include?(card1)
              if c1 == c2 + 1 && c1 == c3 + 2
                @runs << card1
              elsif c1 == c2 - 1 && c1 == c3 + 1
                @runs << card1
              elsif c1 == c2 - 1 && c1 == c3 - 2
                @runs << card1
              end
            end
          end
        end
      end
    end
  end

  def find_melds
    add_cards = Proc.new { |card| @melds << card unless @melds.include?(card) }
    @runs.each(&add_cards)
    @sets.each(&add_cards)
  end

#  def find_cards_in_2_melds
#    @sets.each do |card1|
#      @runs.each do |card2|
#        if card1 == card2
#          puts "Warning: #{card1} is in in two melds"
#        end
#      end
#    end
#  end

  def calc_deadwood
    def find_deadwood_cards
      @cards.each do |card|
        @deadwood_cards << card unless @melds.include?(card)
      end
    end
    def calc_deadwood_count
      @deadwood_cards.each { |card| @deadwood_count += card.value }
    end
    find_deadwood_cards
    calc_deadwood_count
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
