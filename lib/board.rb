require 'ship_position'
require 'set'

class Board
  SHIPS_NUMBER = 5

  def initialize
    @ships_positions = []
    @already_hit = Set.new
  end

  def ready?
    ships.size == SHIPS_NUMBER
  end

  def place_ship!(ship, box, orientation)
    pos = ShipPosition.new(ship, box, orientation)
    check_present_type(ship)
    check_overlaping(pos)
    
    @ships_positions << pos
  end

  def attack!(box)
    raise ArgumentError, "Box already hit" unless @already_hit.exclude?(box)
    @already_hit << box

    ship_at(box)&.attack!(box)
  end

  def all_sunk?
    ships.all?(&:sunk?)
  end

  private

  def ships
    @ships_positions.map(&:ship)
  end

  def ship_at(box)
    @ships_positions.find { |pos| pos.cover?(box) }
  end

  def check_present_type(ship)
    if ships.map(&:type).include?(ship.type)
      raise ArgumentError, "There's already a #{ship.type}"
    end
  end

  def check_overlaping(new_ship_pos)
    if @ships_positions.any? { |pos| pos.overlaps?(new_ship_pos) }
      raise ArgumentError, "Occupied position"
    end
  end
end
