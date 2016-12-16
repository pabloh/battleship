# Represents the ship's position at the board
class BoardPosition
  X_COORDS = 'A'..'J'
  Y_COORDS = 1..10
  ORIENTATIONS = [:vertical, :horizontal].freeze

  attr_reader :x, :y, :length, :orientation

  def initialize(x, y, ship, orientation)
    raise ArgumentError, "Invalid orientation" unless orientation.in?(ORIENTATIONS)
    @x, @y, @length, @orientation = x, y, ship.length, orientation

    check_valid_coordinates
  end

  def overlaps?(board_position)
    boxes.any? { |x, y| board_position.contains?(x, y) }
  end

  def contains?(box_x, box_y)
    boxes.any? { |x, y| box_x == x && box_y == y }
  end

  def self.valid_box?(x, y)
    x.in?(X_COORDS) && y.in?(Y_COORDS)
  end

  private

  def boxes
    return enum_for(:boxes) if !block_given?

    if orientation == :vertical
      length.times { |idx| yield @x, @y + idx }
    else
      length.times { |idx| yield (@x.ord + idx).chr, @y }
    end
  end

  def check_valid_coordinates
    stern_x, stern_y = boxes.to_a.last

    unless self.class.valid_box?(@x, @y) && self.class.valid_box?(stern_x, stern_y)
      raise ArgumentError, "The ship doesn't properly fit at the board"
    end
  end
end
