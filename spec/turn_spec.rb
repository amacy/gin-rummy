require "spec_helper"

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

      expect(@turn._status).to eq @status
      expect(@player.cards).to include @last_discard
      expect(@player.knocked?).to eq false
    end
  end

  describe "#_status" do
    it "returns a string with the status for the current hand" do
      expect(@turn._status).to eq @status
    end
  end

  describe "#_draw" do
    it "allows the player to pick up from the disard pile" do
      ARGV.replace ["y"]
      @turn._draw
      expect(@player.cards).to include @last_discard
    end

    it "allows the player to pick up from the deck" do
      random_card = @deck.remove_card
      ARGV.replace ["n"]
      allow(@deck).to receive(:remove_card) { random_card }

      @turn._draw
      expect(@player.cards).to include random_card
    end
  end

  describe "_discard" do
    it "allows the player to discard one of the cards in their hand" do
      ARGV.replace ["3"]
      @turn._discard
      expect(@player.cards).not_to include @card_to_discard
    end
  end

  describe "_prompt_knock" do
    it "gives the player the opportunity to knock" do
      ARGV.replace ["y"]
      allow(@player).to receive(:can_knock?) { true }
      @turn._prompt_knock
      expect(@player.knocked?).to eq true
    end
  end
end
