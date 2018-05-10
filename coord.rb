class Coord
  EMPTY   = :empty
  INTACT  = :intact
  DAMAGED = :damaged
  BYPASS  = :bypass

  attr_accessor :x, :y, :state, :board, :ship

  def initialize(x, y, board)
    @x     = x
    @y     = y
    @board = board
    @state = EMPTY
  end

  def available?
    empty?
  end

  def empty?
    state == EMPTY
  end

  def intact?
    state == INTACT
  end

  def damaged?
    state == DAMAGED
  end

  def bypass?
    state == BYPASS
  end

  def place_ship(ship)
    @ship  = ship
    @state = INTACT
  end

  def bypass
    @state = BYPASS
  end

  def damage
    @state = DAMAGED
  end

  def empty
    @state = EMPTY
  end

  def value
    @x + @y
  end

  def to_s
    "[#{x}/#{y}]"
  end
end
