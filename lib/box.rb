# Represents a board box
Box = Struct.new(:col, :row) do
  COLS = 'A'..'J'
  ROWS = 1..10

  instance_eval { alias :[] :new }

  def initialize(col, row)
    raise ArgumentError, "Invalid board position" unless col.in?(COLS) && row.in?(ROWS)
    super
    freeze
  end

  def move_to(boxes, orientation)
    if orientation == :vertical
      Box[col, row + boxes]
    elsif orientation == :horizontal
      Box[(col.ord + boxes).chr, row]
    end
  end
end
