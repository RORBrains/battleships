module DrawerStrategies
  module LineAware
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
