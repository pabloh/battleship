class Ship
  TYPES = {
    carrier:    5,
    battleship: 4,
    cruiser:    3,
    submarine:  3,
    destroyer:  2,
  }

  attr_reader :type

  def initialize(type)
    raise ArgumentError, "Invalid type" unless type.in?(TYPES)
    @type = type
    @attacked = [false] * length
  end

  def length
    TYPES[type]
  end

  def attack!(segment)
    raise ArgumentError, "Out of range" unless segment.in?(0..length.pred)
    @attacked[segment] = true
  end

  def sunk?
    @attacked.all?
  end
end
