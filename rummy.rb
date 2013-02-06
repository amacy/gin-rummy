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
  attr_reader :rank, :suit, :value

  def initialize(rank, suit)
    @rank, @suit = RANKS[rank], suit
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
    :eight, :nine, :ten, :jack, :queen, :king

  def initialize(cards)
    @cards, @melds, @runs, @sets = [], [], [], []
    @score = 0
    cards.each { |card| @cards << card }
    RANKS.each_key { |rank| instance_variable_set("@#{rank}", Array.new) }
    SUITS.each { |suit| instance_variable_set("@#{suit}", Array.new) }
  end

  def draw(card)
    @cards << card
  end
  
  def discard(n)
    @cards.delete_at(n)
  end

  def calc_score
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
            c1 = card1.rank
            c2 = card2.rank
            c3 = card3.rank
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
    @melds = @runs.concat(@sets)
  end

  def find_cards_in_2_melds
    @sets.each do |card1|
      @runs.each do |card2|
        if card1 == card2
          puts "Warning: #{card1} is in in two melds"
        end
      end
    end
  end

  def deadwood
  end
end

class Game
  attr_reader :player1, :player2, :deck, :discard_pile, :turn, :whos_turn

  def initialize
    @deck = Deck.new
    @player1 = Player.new(@deck.deal_hand)
    @player2 = Player.new(@deck.deal_hand)
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @turn = 0
    players = []
    players << @player1 << @player2
    @whos_turn = players.sample
  end

  def status
    "TURN #{@turns}:\n" +
    "#{@deck.cards.length} cards left\n" +
    "#{@whos_turn}'s turn"
    # "Your current score is #{score}"
  end

  def new_turn 
    @turn += 1
    #puts status
    #puts draw
    #puts discard
    if @whos_turn = @player1
      @player2
    else
      @player1
    end
  end

  def draw
    puts "Would you like to pick up the #{@discard_pile.top}?"
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
      puts "#{i}: #{card.to_s}"
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
