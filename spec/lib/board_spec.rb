require 'spec_helper'

describe Board do
  describe ".new" do
    it "returns an unpopulated board" do
      expect(Board.new).to_not be_ready
    end
  end

end
