module Messages
  def message(message_name, options = {})
    method_name = "message_#{message_name}"
    public_send(method_name, options)
  end

  def message_x_coord(options)
    ship = options[:ship]
    return unless ship
    format(
      "Set the X coordinate for the first ship (%s [%d/%d]): ",
      ship.name,
      ship.coords.length,
      ship.length
    )
  end

  def message_y_coord_shoot(_options = {})
    "Set the Y coordinate for a shoot: "
  end

  def message_x_coord_shoot(_options = {})
    "Set the X coordinate for a shoot: "
  end

  def message_y_coord(options)
    ship = options[:ship]
    return unless ship
    format(
      "Set the Y coordinate for the first ship (%s [%d/%d]): ",
      ship.name,
      ship.coords.length,
      ship.length
    )
  end

  def message_not_available(options)
    "\n\tERROR! Coordinate #{options[:x]}X#{options[:y]} is not available!\n"
  end

  def message_placement_mode(options)
    mode = options[:mode] == :m ? "a Manual" : "an Automatic"
    puts "You have selected #{mode} placement mode!"
  end

  def message_intro(_options = {})
    "\n#{message(:intro_line)}\n#{" " * 14}Battleships v1.0\n#{message(:intro_line)}\n"
  end

  def message_intro_line(_options = {})
    "=" * 45
  end
end
