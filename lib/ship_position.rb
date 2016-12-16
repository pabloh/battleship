require 'box'
require 'ship'

# Represents the ship's position at the board
class ShipPosition
  ORIENTATIONS = [:vertical, :horizontal].freeze

  attr_reader :ship

  def initialize(ship, bow, orientation)
    raise ArgumentError, "Invalid orientation" unless orientation.in?(ORIENTATIONS)
    stern = bow.move_to(ship.length - 1, orientation)

    @ship, @cols, @rows = ship, bow.col..stern.col, bow.row..stern.row
  end

  def overlaps?(position)
    rows.overlaps?(position.rows) && cols.overlaps?(position.cols)
  end

  def cover?(box)
    cols.cover?(box.col) && rows.cover?(box.row)
  end

  def attack!(box)
    ship.attack!(ship_segment(box))
  end

  protected
  attr_reader :rows, :cols

  def ship_segment(box)
    cols.first == cols.last ? box.row - rows.first : box.col.ord - cols.first.ord
  end
end
