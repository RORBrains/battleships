require "./drawer_strategies/line_aware"

module DrawerStrategies
  class Console
    include LineAware

    CHAR_WIDTH = 3
    BORDER_WIDTH = 1
    LEGEND_WIDTH = 3
    VERTICAL_SPLITTER = "|".freeze
    HORIZONTAL_SPLITTER = "-".freeze

    attr_reader :board

    def initialize(board, _options = {})
      @board = board
    end

    def call(coord, idx)
      state = case coord.state
              when Coord::EMPTY then "   "
              when Coord::INTACT then " S "
              when Coord::DAMAGED then " X "
              when Coord::BYPASS then " e "
              end
      draw_first_line(idx)

      print "#{vertical_legend(idx)} #{VERTICAL_SPLITTER}" if beginning_of_line?(idx)
      print state
      print VERTICAL_SPLITTER
      puts "\n#{horizontal_line}" if end_of_line?(idx)

      draw_last_line(idx)
    end

    private

    def draw_first_line(idx)
      return unless first_line?(idx) && beginning_of_line?(idx)
      puts
      puts horizontal_legend
      puts horizontal_line
    end

    def draw_last_line(idx)
      return unless end_of_line?(idx) && last_line?(idx)
      puts horizontal_legend
      puts
    end

    def vertical_legend(idx)
      line_number = (idx / board.width) + 1
      format_number(line_number)
    end

    def horizontal_legend
      rows_legend = (1..board.width).to_a.map do |row_num|
        " #{format_number(row_num)}"
      end.join(" ")
      "#{legend_indent}#{rows_legend}"
    end

    def format_number(number)
      format("%0.2d", number)
    end

    def horizontal_line
      line_length = (board.width * CHAR_WIDTH + (board.width + 1) * BORDER_WIDTH)
      legend_indent + HORIZONTAL_SPLITTER * line_length
    end

    def legend_indent
      @_legend_indent ||= " " * LEGEND_WIDTH
    end
  end
end
