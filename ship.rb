class Ship
  MAX_LENGTH = 4

  class << self
    def how_many_ships(length)
      case length
      when 4 then 1 when 3 then 2
      when 2 then 3
      when 1 then 4
      else 0
      end
    end

    def ship_name(length)
      case length
      when 4 then :battleship
      when 3 then :cruiser
      when 2 then :destroyer
      when 1 then :submarine
      else :unknown
      end
    end

    def max_ships_count
      @_max_ships_count ||= (1..MAX_LENGTH).sum do |length|
        how_many_ships(length)
      end
    end

    def build_all_ships
      ships = []
      (1..MAX_LENGTH).each do |length|
        count_of_ships = how_many_ships(length)
        count_of_ships.times { ships << new(length, ship_name(length)) }
      end
      ships
    end
  end

  attr_accessor :length, :name, :coords

  def initialize(length, name = nil)
    @length = length
    @name   = name
    @coords = []
  end

  def <<(coord)
    add_coordinate(coord)
  end

  def add_coordinate(coord)
    @coords << coord

    sort_coords

    if valid_coordinates?
      coord.place_ship(self)
    else
      destroy
    end
  end

  def not_started?
    coords.empty?
  end

  def complete?
    coords.count == length
  end

  def damaged?
    coords.any?(&:damaged?)
  end

  def drawned?
    coords.all?(&:damaged?)
  end

  def destroy
    @coords.map(&:empty)
    @coords = []
  end

  private

  def sort_coords
    coords.sort_by!(&:value)
  end

  def valid_coordinates?
    appropriate_count_of_coordinates? &&
      all_coordinates_in_a_row? &&
      acceptable_distance?
  end

  def appropriate_count_of_coordinates?
    @coords.length <= @length
  end

  def all_coordinates_in_a_row?
    (coords.map(&:y).uniq.count == 1) ||
      (coords.map(&:x).uniq.count == 1)
  end

  def acceptable_distance?
    puts "#{coords.last.value - coords.first.value} <= #{@length}"
    (coords.last.value - coords.first.value) <= @length
  end
end
