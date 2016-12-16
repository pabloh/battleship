require 'spec_helper'

describe BoardPosition do
  let(:ship) { Ship.new(:destroyer) }

  describe ".new", :aggregate_failures do
    it "accepts only valid positions" do
      expect { BoardPosition.new('A', 1, ship, :diagonal) }.to raise_error(ArgumentError)
      expect { BoardPosition.new('Z', 1, ship, :vertical) }.to raise_error(ArgumentError)
      expect { BoardPosition.new('A', 10, ship, :vertical) }.to raise_error(ArgumentError)

      BoardPosition.new('B', 2, ship, :horizontal)
    end
  end

  let(:position) { BoardPosition.new('B', 2, ship, :horizontal) }

  describe "#contains?" do
    it "returns true for a box inside the ship" do
      expect(position.contains?('B', 2)).to be_truthy
    end

    it "returns false for a box outside the ship" do
      expect(position.contains?('B', 4)).to be_falsy
    end
  end

  describe "#overlaps?" do
    it "returns true for a position inside the ship" do
      overlaping = BoardPosition.new('C', 2, ship, :vertical)
      expect(position.overlaps?(overlaping)).to be_truthy
    end

    it "returns false for a position outside the ship" do
      non_overlaping = BoardPosition.new('D', 2, ship, :vertical)
      expect(position.overlaps?(non_overlaping)).to be_falsy
    end
  end
end
