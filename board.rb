require "./coord"

class Board
  attr_reader :height, :width, :coords, :size, :ordered_coords

  attr_accessor :drawer

  def initialize(width = 10, height = 10)
    @width  ||= width
    @height ||= height
    @drawer ||= -> { puts "" }
    @coords ||= []
    @ordered_coords ||= []
    @size = 0
  end

  def find_coord(x, y)
    return unless x >= 0 && y >= 0
    return unless @ordered_coords[y]
    @ordered_coords[y][x]
  end

  def random_coord
    @coords.sample
  end

  def draw
    build_coords(width, height) if coords.empty?
    coords.each_with_index do |coord, idx|
      drawer.call(coord, idx)
    end
  end

  private

  def build_coords(width, height)
    (0...height).each do |y|
      @ordered_coords[y] = []
      (0...width).each do |x|
        coord = Coord.new(x, y, self)
        coords << coord
        @ordered_coords[y][x] = coord
        @size += 1
      end
    end
  end
end
