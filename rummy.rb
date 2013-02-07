#!/usr/bin/env ruby

SUITS = [:clubs, :diamonds, :hearts, :spades]
RANKS = {
  ace: 1,
  two: 2,
  three: 3,
  four: 4, 
  five: 5, 
  six: 6, 
  seven: 7, 
  eight: 8, 
  nine: 9, 
  ten: 10, 
  jack: 11,
  queen: 12,
  king: 13
}

class Card
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

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    full
    @cards.shuffle!
  end

  def full
    SUITS.each do |suit| 
      RANKS.each_key do |rank| 
        @cards << Card.new(rank, suit)
      end
    end
  end

  def remove_card
    card = @cards.sample
    @cards.delete(card)
    card
  end

  def deal_hand
    hand = []
    10.times do
      hand << remove_card
    end
    hand
  end  
end

class Player
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
end

class Game
  attr_reader :player1, :player2, :deck, :discard_pile, :turn, :whos_turn, :knock

  def initialize
    @deck = Deck.new
    @player1 = Player.new(@deck.deal_hand)
    @player2 = Player.new(@deck.deal_hand)
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @turn = 0
    players = []
    players << @player1 << @player2
    @whos_turn = players.sample
    @knock = false
  end

  def status
    "TURN #{@turns}:\n" +
    "Stock pile: #{@deck.cards.length}\n" +
    "#{@whos_turn}'s turn\n" +
    "Your deadwood count is #{@whos_turn.deadwood_count}. #{alert_knock}"
  end

  def draw
    puts "Would you like to pick up the #{@discard_pile.top.name}?"
    if gets.chomp == 'y'
      @whos_turn.draw(@discard_pile.top)
    else
      @whos_turn.draw(@deck.remove_card)
    end
  end

  def discard
    i = 0
    puts "Which card would you like to discard?\n"
    @whos_turn.cards.each do |card|
      puts "#{i}: #{card.name}"
      i += 1
    end
    n = gets.chomp
    if n < 0 || n > 10
      puts "Invalid input"
      return self
    else
      @whos_turn.discard(n)
    end
  end

  def alert_knock
    'You can knock!' if @whos_turn.can_knock?
  end
  
  def prompt_knock
    if @whos_turn.can_knock?
      'Would you like to knock? (y/n)'
      if gets.chomp == 'y'
        @knock = true
      end
    end
  end

  def alert_gin
    'You have gin!' if @whos_turn.gin?
  end

  def game_over?
  end

  def game_over
  end

  def hand_over?
    if @knock || @whos_turn.gin? || @deck.cards.length == 0
      true
    else
      false
    end
  end

  def play_turn 
    @turn += 1
    #puts status
    #puts draw
    #puts discard
    alert_knock
    alert_gin
    #next_turn unless hand_over?
  end

  def next_turn
    if @whos_turn == @player1
      @whos_turn = @player2
    else
      @whos_turn = @player1
    end
    play_turn
  end

  def calc_score
  end
end

class DiscardPile
  attr_reader :cards

  def initialize(card)
    @cards = [card]
  end

  def top
    @cards.last
  end
end
