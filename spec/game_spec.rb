require "spec_helper"

RSpec.describe Game do
  before do
    @game = Game.new
    @game.play
  end

  describe "#play" do
    it "plays out a game" do
      skip
      # lots of setup required for this test
    end
  end

  describe "final_score" do
    it "calculates the score for both players" do
      skip
    end
  end
end
