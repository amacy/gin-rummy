require "spec_helper"

RSpec.describe Game do
  before do
    @game = Game.new
    @game.play
  end

  describe "#play" do
    it "plays out a game" do
      game = Game.new
      game.play
      expect(game.winner).to_not be_nil
    end
  end

  describe "final_score" do
    it "calculates the score for both players"
    it "adds 25 for gin"
    it "adds 25 points for undercutting"
  end
end
