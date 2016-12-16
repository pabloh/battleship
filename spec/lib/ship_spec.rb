require 'spec_helper'

describe Ship do
  describe ".new" do
    it "accepts a valid battleship type" do
      ship = Ship.new(:carrier)
      expect(ship.type).to eq(:carrier)
    end
  
    it "rejects an invalid battleship type" do
      expect { Ship.new(:fishing_boat) }.to raise_error(ArgumentError)
    end
  end

  let(:ship) { Ship.new(:destroyer) }

  describe "#sunk?" do
    it "returns true when the ship has been sunk" do
      ship.attack!(0)
      ship.attack!(1)
      expect(ship).to be_sunk
    end

    it "returns false when the ship is afloat" do
      ship.attack!(0)
      expect(ship).to_not be_sunk
    end
  end

  describe "#attack!" do
    it "returns true on a successful attack" do
      expect(ship.attack!(1)).to be(true)
    end

    it "rejects an invalid segment" do
      expect { ship.attack!(2) }.to raise_error(ArgumentError)
    end
  end

  describe "#length" do
    it "returns the ship's lenght" do
      ship = Ship.new(:destroyer)
      expect(ship.length).to eq(2)
    end
  end
end
