class Turn
  attr_reader :hand

  def initialize(hand, discard_pile, deck, output=STDOUT)
    @hand = hand
    @discard_pile = discard_pile
    @deck = deck
    @output = output
  end

  def play
    @output.puts _status
    _draw
    _discard
    _prompt_knock if _alert_knock
    _alert_gin
  end

  def _status
<<-STATUS
Stock pile: #{@deck.cards.length}
#{@hand}'s turn
Your deadwood count is #{@hand.deadwood_count}.
STATUS
  end

  def _draw
    @output.puts "Would you like to pick up the #{@discard_pile.top.name}? y/n"

    if ARGV.shift == "y"
      @hand.draw(@discard_pile.top)
    else
      @hand.draw(@deck.remove_card)
    end
  end

  def _discard
    @output.puts "Which card would you like to discard?"

    @hand.cards.each_with_index do |card, index|
      @output.puts "#{index}: #{card.name}"
    end

    index_to_delete = ARGV.shift.to_i
    if (0..10).include?(index_to_delete)
      @hand.discard(index_to_delete)
    else
      # will need a real solution to this eventually
      raise "Out of range"
    end
  end

  def _alert_gin
    "You have gin!" if @hand.gin?
  end

  def _alert_knock
    "You can knock!" if @hand.can_knock?
  end

  def _prompt_knock
    if @hand.can_knock?
      "Would you like to knock? (y/n)"
      @hand.knock! if ARGV.shift == "y"
    end
  end
end
