require 'spec_helper'

describe ShipPosition do
  let(:ship) { Ship.new(:destroyer) }

  describe ".new", :aggregate_failures do
    it "accepts only valid positions", :aggregate_failures do
      expect { ShipPosition.new(ship, Box['B', 2], :horizontal) }.
        to_not raise_error
      expect { ShipPosition.new(ship, Box['A', 1], :diagonal) }.
        to raise_error(ArgumentError, "Invalid orientation")
      expect { ShipPosition.new(ship, Box['Z', 1], :vertical) }.
        to raise_error(ArgumentError, "Invalid board position")
      expect { ShipPosition.new(ship, Box['A', 10], :vertical) }.
        to raise_error(ArgumentError, "Invalid board position")
    end
  end

  let(:position) { ShipPosition.new(ship, Box['B', 2], :horizontal) }

  describe "#attack!" do
    let(:ship) { instance_double(Ship, length: 3) }
    it "hits the ship at the right segment" do
      expect(ship).to receive(:attack!).with(1)

      position.attack!(Box['C', 2])
    end
  end

  describe "#cover?" do
    it "returns true for a box inside the ship" do
      expect(position.cover?(Box['B', 2])).to be_truthy
    end

    it "returns false for a box outside the ship" do
      expect(position.cover?(Box['B', 4])).to be_falsy
    end
  end

  describe "#overlaps?" do
    let(:overlaping) { [ShipPosition.new(ship, Box['C', 2], :vertical),
                        ShipPosition.new(ship, Box['A', 2], :horizontal)] }

    let(:non_overlaping) { [ShipPosition.new(ship, Box['D', 2], :vertical),
                            ShipPosition.new(ship, Box['B', 3], :horizontal)] }

    it "returns true for a ship position overlaping the ship", :aggregate_failures do
      expect(position.overlaps?(overlaping[0])).to be_truthy
      expect(position.overlaps?(overlaping[1])).to be_truthy
    end

    it "returns false for a ship position outside the ship", :aggregate_failures do
      expect(position.overlaps?(non_overlaping[0])).to be_falsy
      expect(position.overlaps?(non_overlaping[1])).to be_falsy
    end
  end
end
