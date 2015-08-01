require "minitest/autorun"
require_relative "../lib/player"

describe Player do
  before do
    @deck = Deck.new
    @drawn_card = @deck.remove_card
    @player = Player.new(@deck.deal_hand)
  end

  describe "#initialize" do
    it "should set some instance variables" do
      @player.cards.must_be_instance_of Array
      @player.cards.length.must_equal 10
      @player.score.must_equal 0
      @player.deadwood_count.must_equal 0
      @player.deadwood_cards.must_equal []
      @player.sets.must_equal []
      @player.seven.must_equal []
      @player.runs.must_equal []
      @player.spades.must_equal []
      @player.melds.must_equal []
    end
  end

  describe "#draw" do
    before do
      @player.draw(@drawn_card)
    end
    it "should add a card to the player's hand" do
      @player.cards.length.must_equal 11
      @player.cards.last.must_equal @drawn_card
      @player.cards.last.must_be_instance_of Card
    end

    describe "#discard" do
      before do
        @player.discard(10)
      end

      it "should remove a card from the player's hand" do
        @player.cards.length.must_equal 10
        @player.cards.last.wont_equal @drawn_card
        @player.cards.last.must_be_instance_of Card
      end
    end
  end

  describe "#find_sets" do
    before do
      @card1 = Card.new(:ace, :diamonds)
      @card2 = Card.new(:ace, :clubs)
      @card3 = Card.new(:ace, :spades)
      @card4 = Card.new(:two, :clubs)
      @card5 = Card.new(:three, :clubs)
      @card6 = Card.new(:four, :clubs)
      @card7 = Card.new(:seven, :clubs)
      @card8 = Card.new(:four, :diamonds)
      @card9 = Card.new(:five, :diamonds)
      @cards = [@card1, @card2, @card3, @card4, @card5,
                @card6, @card7, @card9, @card8]
      @player2 = Player.new(@cards)
      @player2.find_sets
    end

    it "should return an array of sets" do
      @player2.ace.must_include @card1
      @player2.ace.must_include @card2
      @player2.ace.must_include @card3
      @player2.sets.must_include @card1
      @player2.sets.must_include @card2
      @player2.sets.must_include @card3
      @player2.two.wont_include @card4
      @player2.three.wont_include @card5
      @player2.four.wont_include @card6
      @player2.seven.wont_include @card7
      @player2.four.wont_include @card8
      @player2.five.wont_include @card9
    end

    describe "#sort_hand" do
      before do
        @player2.sort_hand
      end

      it "should order the cards by rank" do
        @player2.cards.last.must_equal @card7
      end

      describe "#sort_be_suit" do
        before do
          @player2.sort_by_suit
        end

        it "should sort cards by suit" do
          @player2.clubs.must_include @card2
          @player2.clubs.must_include @card4
          @player2.clubs.must_include @card5
          @player2.clubs.must_include @card6
          @player2.clubs.must_include @card7
          @player2.clubs.length.must_equal 5
          @player2.diamonds.must_include @card1
          @player2.diamonds.must_include @card8
          @player2.diamonds.must_include @card9
          @player2.diamonds.length.must_equal 3
          @player2.spades.must_include @card3
          @player2.spades.length.must_equal 1
          @player2.hearts.length.must_equal 0
        end

        describe "#find_runs" do
          before do
            @player2.find_runs
          end

          it "should return an array of runs" do
            @player2.runs.must_include @card2
            @player2.runs.must_include @card4
            @player2.runs.must_include @card5
            @player2.runs.must_include @card6
            @player2.runs.length.must_equal 4
          end

          describe "#find_melds" do
            before do
              @player2.find_melds
            end

            it "should return an array of all the cards in melds" do
              @player2.melds.must_include @card1
              @player2.melds.must_include @card2
              @player2.melds.must_include @card3
              @player2.melds.must_include @card4
              @player2.melds.must_include @card5
              @player2.melds.must_include @card6
              @player2.melds.length.must_equal 6
            end

#          describe "#find_cards_in_2_melds" do
#            before do
#              @player2.find_cards_in_2_melds
#            end
#
#            it "should"

            describe "#calc_deadwood" do
              before do
                @player2.calc_deadwood
              end

              it "should calc the total deadwood" do
                @player2.deadwood_cards.must_include @card7
                @player2.deadwood_cards.must_include @card8
                @player2.deadwood_cards.must_include @card9
                @player2.deadwood_cards.length.must_equal 3
                @player2.deadwood_count.must_equal 16
              end

              describe "#gin?" do
                before do
                  @player3 = Player.new([@card1, @card2, @card3,
                                         @card4, @card5, @card6])
                  @player3.sort_hand
                  @player3.sort_by_suit
                  @player3.find_sets
                  @player3.find_runs
                  @player3.find_melds
                  @player3.calc_deadwood
                end

                it "should return true when gin" do
                  @player3.gin?.must_equal true
                end

                it "should return false otherwise" do
                  @player2.gin?.must_equal false
                end

                describe "#can_knock?" do
                  it "should return true when deadwood <= 10" do
                    @player3.can_knock?.must_equal true
                  end

                  it "should return false otherwise" do
                    @player2.can_knock?.must_equal false
                  end
                end
              end

                describe "#undercut" do
                end

            end
          end
        end
      end
    end
  end
end

