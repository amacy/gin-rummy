$suits = %w(Clubs Diamonds Hearts Spades)
A = 'Ace'
J = 'Jack'
Q = 'Queen'
K = 'King'
$ranks = [A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K]

class Card
  attr_reader :rank, :suit, :value

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def calc_value
    if @rank == 'Ace'
      @value = 1
    elsif @rank.instance_of?(String)
      @value = 10
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
    $suits.each do |suit| 
      $ranks.each do |rank| 
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
  attr_reader :cards, :score, :sets, :runs

  def initialize(cards)
    @cards = []
    @score = 0
    cards.each { |card| @cards << card }
    @sets = {}
    @runs = {}
    $ranks.each { |rank| @sets[rank] = Array.new }
    $suits.each { |suit| @runs[suit] = Array.new }
  end

  def draw(card)
    @cards << card
  end
  
  def discard(n)
    @cards.delete_at(n)
  end

  def calc_score
  end

  def find_sets
    $ranks.each do |rank|
      @cards.each do |card|
        @sets[rank] << card if card.rank == rank
      end
    end
  end

  def find_runs
    $suits.each do |suit|
      @cards.each do |card|
        @runs[suit] << card if card.suit == suit
      end
    end
  end

  def find_cards_in_2_melds
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
