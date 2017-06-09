require "spec_helper"

describe Turn do
  before do
    @deck = Deck.new
    @hand = Hand.new(@deck.deal_hand)
    @discard_pile = DiscardPile.new(@deck.remove_card)
    @output = ""
    @turn = Turn.new(@hand, @discard_pile, @deck, StringIO.new(@output))

    @status = <<-STATUS
Stock pile: 41
#{@hand}'s turn
Your deadwood count is #{@hand.deadwood_count}.
STATUS
    @last_discard = @discard_pile.top
    @card_to_discard = @hand.cards[3]
  end

  describe "#play" do
    it "plays an entire turn" do
      ARGV.replace ["y", "3"]
      @turn.play

      expect(@turn._status).to eq @status
      expect(@hand.cards).to include @last_discard
      expect(@hand.knocked?).to eq false
    end
  end

  describe "#_status" do
    it "returns a string with the status for the current hand" do
      expect(@turn._status).to eq @status
    end
  end

  describe "#_draw" do
    it "allows the hand to pick up from the disard pile" do
      ARGV.replace ["y"]
      @turn._draw
      expect(@hand.cards).to include @last_discard
    end

    it "allows the hand to pick up from the deck" do
      random_card = @deck.remove_card
      ARGV.replace ["n"]
      allow(@deck).to receive(:remove_card) { random_card }

      @turn._draw
      expect(@hand.cards).to include random_card
    end
  end

  describe "_discard" do
    it "allows the hand to discard one of the cards in their hand" do
      ARGV.replace ["3"]
      @turn._discard
      expect(@hand.cards).not_to include @card_to_discard
    end
  end

  describe "_prompt_knock" do
    it "gives the hand the opportunity to knock" do
      ARGV.replace ["y"]
      allow(@hand).to receive(:can_knock?) { true }
      @turn._prompt_knock
      expect(@hand.knocked?).to eq true
    end
  end
end
