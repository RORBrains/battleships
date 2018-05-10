class User
  attr_accessor :board, :ships, :mode

  def initialize(board)
    @board = board
    @ships = []
    @direction = nil
    @next_coord = nil
  end

  def ships_left_to_build
    Ship.max_ships_count - ships.length
  end

  def ships_left
    @ships.reject(&:drawned?).count
  end

  def ships_left?
    ships_left > 0
  end

  def choose_next_coord(current_ship)
    if mode == :m
      manually_request_next_coord(current_ship)
    else
      automatically_choose_next_coord(current_ship)
    end
  end

  def choose_mode
    begin
      print "Select ships placement mode [A for Automatic/M for Manual]:"
      @mode = gets.chomp.downcase.to_sym
    end until %i[a m].include?(@mode)
  end

  private

  def manually_request_next_coord(current_ship)
    print message(:x_coord, ship: current_ship)
    x_coord = gets.chomp.to_i

    print message(:y_coord, ship: current_ship)
    y_coord = gets.chomp.to_i

    board.find_coord(x_coord - 1, y_coord - 1)
  end

  def automatically_choose_next_coord(current_ship)
    change_direction_and_starting_point(current_ship)
    return unless @next_coord

    current_coord = @next_coord
    next_x, next_y = if @direction == :vertical
                       [current_coord.x, current_coord.y + 1]
                     else
                       [current_coord.x + 1, current_coord.y]
                     end
    @next_coord = board.find_coord(next_x, next_y)

    current_coord
  end

  def change_direction_and_starting_point(current_ship)
    return unless current_ship.not_started?
    @direction = choose_direction
    @next_coord = @board.random_coord
  end

  def choose_direction
    (rand.round == 0) ? :vertical : :horizontal
  end
end
