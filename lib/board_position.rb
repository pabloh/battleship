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
    board_position.boxes.any? { |x, y| contains?(x ,y) }
  end

  def contains?(x, y)
    boxes.any? { |x, y| box_x == x && box_y == y }
  end

  def boxes
    if orientation == :vertical
      length.times { |idx| yield @x, @y + idx }
    else
      length.times { |idx| yield (@x.ord + idx).chr, @y + 1 }
    end
  end

  private

  def calculate_stern_coordinates
    if orientation == :vertical
      [@x, @y + length]
    else
      [(@x.ord + length).chr, @y] 
    end
  end

  def check_valid_coordinates
    stern_n, stern_y = calculate_stern_coordinates

    unless valid_position?(@x, @y) && valid_position?(stern_x, stern_y)
      raise ArgumentError, "The ship doesn't properly fit at the board" unless type.in?(TYPES)
    end
  end

  def valid_position?(x, y)
    x.in?(X_COORDS) && y.in?(Y_COORDS)
  end
end
