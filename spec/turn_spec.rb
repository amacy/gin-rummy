require "pry"
require "minitest/autorun"
require_relative "../lib/deck"
require_relative "../lib/player"
require_relative "../lib/discard_pile"
require_relative "../lib/turn"

describe Turn do
  # TODO: remove noise from stdout

  before do
    @deck = Deck.new
    @player = Player.new(@deck.deal_hand)
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @turn = Turn.new(@player, @discard_pile, @deck)

    @status = <<-STATUS
Stock pile: 41
#{@player}'s turn
Your deadwood count is #{@player.deadwood_count}.
STATUS
    @last_discard = @discard_pile.top
    @card_to_discard = @player.cards[3]
  end

  describe "#play" do
    it "plays an entire turn" do
      ARGV.replace ["y", "3"]
      @turn.play

      @turn._status.must_equal @status
      @player.cards.must_include @last_discard
      @player.knocked?.must_equal false
    end
  end

  describe "#_status" do
    it "returns a string with the status for the current hand" do
      @turn._status.must_equal @status
    end
  end

  describe "#_draw" do
    it "allows the player to pick up from the disard pile" do
      ARGV.replace ["y"]
      @turn._draw
      @player.cards.must_include @last_discard
    end

    it "allows the player to pick up from the deck" do
      random_card = @deck.remove_card
      ARGV.replace ["n"]
      @deck.stub :remove_card, random_card do
        @turn._draw
      end

      @player.cards.must_include random_card
    end
  end

  describe "_discard" do
    it "allows the player to discard one of the cards in their hand" do
      ARGV.replace ["3"]
      @turn._discard
      @player.cards.wont_include @card_to_discard
    end
  end

  describe "_prompt_knock" do
    it "gives the player the opportunity to knock" do
      ARGV.replace ["y"]
      @player.stub :can_knock?, true do
        @turn._prompt_knock
      end
      @player.knocked?.must_equal true
    end
  end
end
