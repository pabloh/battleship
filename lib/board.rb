require 'ship'
require 'set'

class Board
  def initialize
    @ships_positions = {}
    @already_hit = Set.new
  end

  def ready?
    ships.size == 5
  end

  def place_ship!(ship, x, y, orientation)
    pos = BoardPosition.new(x, y, ship, orientation)
    check_already_placed(ship)
    check_overlaping(pos)
    
    @ships_positions[ship] = pos 
  end

  def attack!(x, y)
    raise ArgumentError, "You've already that box" unless @already_hit.exclude([x, y])
    @already_hit << [x, y]

    if ship = ship_at(x, y)
      ship.attack!(position(ship).segment)
    end
  end

  def all_sunk?
    ships.keys.all?(:sunk?)
  end

  private

  def ships
    @ships_positions.keys
  end

  def check_already_placed(ship)
    if ships.keys.map(&:type).include?(ship.type)
      raise ArgumentError, "There is #{ship.type} already"
    end
  end

  def ship_at(x, y)
    @ships_positions.each do |ship, pos|
      return ship if pos.contains?(x,y)
    end
  end

  def check_overlaping(new_ship_pos)
    if @ships_positions.values.any? { |pos| pos.overlaps?(new_ship_pos) }
      raise ArgumentError, "There is a ship already in that position"
    end
  end
end
