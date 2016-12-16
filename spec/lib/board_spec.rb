require 'spec_helper'

describe Board do
  describe ".new" do
    it "returns an unpopulated board" do
      expect(Board.new).to_not be_ready
    end
  end

  describe "#place_ship!" do
    let(:board) { Board.new }

    it "is not ready when it has less than 5 ships" do
      Ship::TYPES.keys.take(4).each_with_index do |type, idx|
        board.place_ship!(Ship.new(type), Box['A', idx + 1], :horizontal)
      end
      
      expect(board).to_not be_ready
    end

    it "is ready when it has one ship of each kind" do
      Ship::TYPES.keys.each_with_index do |type, idx|
        board.place_ship!(Ship.new(type), Box['A', idx + 1], :horizontal)
      end
      
      expect(board).to be_ready
    end

    it "doesn't allow more that one ship of the same kind" do
      board.place_ship!(Ship.new(:destroyer), Box['A', 1], :horizontal)
      board.place_ship!(Ship.new(:submarine), Box['A', 2], :horizontal)

      expect { board.place_ship!(Ship.new(:destroyer), Box['A', 3], :horizontal) }.
        to raise_error(ArgumentError, "There's already a destroyer")
    end

    it "doesn't allow overlaping ships" do
      board.place_ship!(Ship.new(:destroyer), Box['A', 1], :horizontal)

      expect { board.place_ship!(Ship.new(:submarine), Box['B', 1], :vertical) }.
        to raise_error(ArgumentError, "Occupied position")
    end
  end

  let(:populated_board) { 
    Board.new.tap do |board|
      Ship::TYPES.keys.each_with_index do |type, idx|
        board.place_ship!(Ship.new(type), Box['C', idx + 3], :horizontal)
      end
    end
  }

  describe "#attack!" do
    it "returns true when you hit a ship" do
      expect(populated_board.attack!(Box['C', 3])).to be_truthy
    end

    it "fails on double hit" do
      expect(populated_board.attack!(Box['C', 3]))
      expect { populated_board.attack!(Box['C', 3]) }.to raise_error(ArgumentError, "Box already hit")
    end

    it "returns false when you don't hit a ship" do
      expect(populated_board.attack!(Box['F', 5])).to be_falsy
    end
  end

  describe "#all_sunk?" do
    it "returns true if all ships are sunk" do
      expect(populated_board.all_sunk?).to be_falsy
      COLS.each { |x| ROWS.each { |y| populated_board.attack!(Box[x ,y]) } }

      expect(populated_board.all_sunk?).to be_truthy
    end 
  end
end
