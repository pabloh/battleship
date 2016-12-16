require 'spec_helper'

describe Game do
  describe ".new" do
    it "rejects non ready boards" do
      expect { Game.new(instance_double(Board, ready?: true), 
                        instance_double(Board, ready?: false)) }.
        to raise_error(ArgumentError, "Invalid board for player 2")
    end

    it "sets the 1st turn to player 1" do
      game = Game.new(instance_double(Board, ready?: true), 
                      instance_double(Board, ready?: true))

      expect(game.turn).to be(1)
    end
  end

  describe "#attack!" do
    let(:board1) { instance_double(Board, ready?: true, attack!: false) }
    let(:board2) { instance_double(Board, ready?: true, attack!: false) }
    let(:game) { Game.new(board1, board2) }

    it "changes the turn" do
      expect { game.attack!(1, Box['A', 1])}.to change { game.turn }.from(1).to(2)
    end

    it "rejects an attack when the turn is wrong" do
      expect { game.attack!(2, Box['A', 1])}.to raise_error(ArgumentError, "Invalid player")
    end

    it "hits the correct board" do
      expect(game.turn).to be(1)
      game.attack!(1, Box['A', 1])

      expect(board1).to receive(:attack!).with(Box['G', 5])
      expect(board2).to_not receive(:attack!)

      game.attack!(2, Box['G', 5])
    end
  end

  describe "#game_over?" do
    it "returns true when a player won" do
      game = Game.new(instance_double(Board, ready?: true, all_sunk?: true),
                      instance_double(Board, ready?: true, all_sunk?: false))

      expect(game.game_over?).to be_truthy
    end

    it "returns false when no player won" do
      game = Game.new(instance_double(Board, ready?: true, all_sunk?: false),
                      instance_double(Board, ready?: true, all_sunk?: false))

      expect(game.game_over?).to be_falsy
    end
  end

  describe "#winner" do
    it "returns the winning player number when there's one" do
      game = Game.new(instance_double(Board, ready?: true, all_sunk?: true),
                      instance_double(Board, ready?: true, all_sunk?: false))

      expect(game.winner).to be(2)
    end
  end
end
