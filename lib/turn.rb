class Turn

  attr_reader :player

  def initialize(player, discard_pile, deck)
    @player = player
    @discard_pile = discard_pile
    @deck = deck
  end

  def play
    puts _status
    _draw
    _discard
    _prompt_knock if _alert_knock
    _alert_gin
  end

  def _status
<<-STATUS
Stock pile: #{@deck.cards.length}
#{@player}'s turn
Your deadwood count is #{@player.deadwood_count}.
STATUS
  end

  def _draw
    puts "Would you like to pick up the #{@discard_pile.top.name}? y/n"

    if ARGV.shift == "y"
      @player.draw(@discard_pile.top)
    else
      @player.draw(@deck.remove_card)
    end
  end

  def _discard
    puts "Which card would you like to discard?"

    @player.cards.each_with_index do |card, index|
      puts "#{index}: #{card.name}"
    end

    index_to_delete = ARGV.shift.to_i
    if (0..10).include?(index_to_delete)
      @player.discard(index_to_delete)
    else
      # will need a real solution to this eventually
      raise "Out of range"
    end
  end

  def _alert_gin
    "You have gin!" if @player.gin?
  end

  def _alert_knock
    "You can knock!" if @player.can_knock?
  end

  def _prompt_knock
    if @player.can_knock?
      "Would you like to knock? (y/n)"
      @player.knock! if ARGV.shift == "y"
    end
  end
end
