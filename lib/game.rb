require_relative 'deck'
require_relative 'discard_pile'
require_relative 'player'

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
