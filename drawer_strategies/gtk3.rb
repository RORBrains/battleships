require "gtk3"

module DrawerStrategies
  class Gtk3

    attr_reader :board, :app, :window, :grid, :orig_board

    def initialize(board, options = {})
      @board      = board
      @orig_board = options[:orig_board] # user1 boar
      @user       = options[:user] # user
      initialize_app
    end

    def call(coord, idx)
      button = Gtk::Button.new(label: draw_state(coord.state))

      button.signal_connect("clicked") do |button|
        button_callback(button, coord)
      end

      @grid.attach(button, coord.x, coord.y, 1, 1)

      draw_last_line(idx)
    end

    private

    def initialize_app
      @app        = Gtk::Application.new("org.gtk.example", :flags_none)
      @grid       = Gtk::Grid.new
      @app.signal_connect "activate" do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title("Window")
        window.set_border_width(10)
        window.add(@grid)
        window.show_all
      end
    end

    def button_callback(button, coord)
      draw_coord_state_on_button(button, coord)

      ships_left = @user.ships_left
      puts "Ships left: #{ships_left}"

      @app.windows.first.destroy if ships_left.zero?
    end

    def draw_coord_state_on_button(button, coord)
      orig_coord = orig_board.find_coord(coord.x, coord.y)

      if orig_coord.empty?
        bypass_coords(coord)
      else
        damage_coords(coord)
      end
      button.label = draw_state(coord.state)
    end

    def damage_coords(coord)
      board.find_coord(coord.x, coord.y).damage
      orig_board.find_coord(coord.x, coord.y).damage
    end

    def bypass_coords(coord)
      board.find_coord(coord.x, coord.y).bypass
      orig_board.find_coord(coord.x, coord.y).bypass
    end

    def draw_state(state)
      case state
      when Coord::EMPTY then "   "
      when Coord::INTACT then " S "
      when Coord::DAMAGED then " ☠ "
      when Coord::BYPASS then " ° "
      end
    end

    def draw_first_line(idx)
      return unless first_line?(idx) && beginning_of_line?(idx)
      puts
      puts horizontal_legend
      puts horizontal_line
    end

    def draw_last_line(idx)
      return unless end_of_line?(idx) && last_line?(idx)
      status = @app.run([$0] + ARGV)
      puts status
    end

    def first_line?(idx)
      idx < board.width
    end

    def last_line?(idx)
      idx >= last_line_first_coord
    end

    def beginning_of_line?(idx)
      (idx % board.width).zero?
    end

    def end_of_line?(idx)
      ((idx + 1) % board.width).zero?
    end

    def last_line_first_coord
      @_last_line_first_coord ||= (board.size - board.width)
    end
  end
end

