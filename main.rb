#! /usr/bin/env ruby

require "pry"
require "./board"
require "./ship"
require "./user"
require "./drawer"
require "./messages"

include Messages

board = Board.new(10, 10)
board.drawer = Drawer.new(:console, board)
user = User.new(board)

puts "\n#{"=" * 45}\n#{" " * 10}Battleships v1.0\n#{"=" * 45}\n"

board.draw

user.choose_mode
puts message(:placement_mode, mode: user.mode)

# User #1
#
puts "You have to build 10 ships to start the game..."
all_ships = Ship.build_all_ships
current_ship = all_ships.pop
while user.ships_left_to_build > 0
  puts "#{user.ships_left_to_build} ships left to build!"

  coord = user.choose_next_coord(current_ship)

  if coord && coord.available?
    current_ship << coord
    if current_ship.complete?
      user.ships << current_ship
      current_ship = all_ships.pop
    end
  else
    puts message(:not_available, x: coord.x, y: coord.y) if coord
    current_ship.destroy
  end

  board.draw
end

# User #2
#
board2 = Board.new(10, 10)
board2.drawer = Drawer.new(:console, board)

user2 = User.new(board2)

puts "Hit all enemies ships!"
while user.ships_left?
  board2.draw

  puts "Ships left: #{user.ships_left}"

  print message(:x_coord_shoot)
  x_coord = gets.chomp.to_i

  print message(:y_coord_shoot)
  y_coord = gets.chomp.to_i

  coord = board.find_coord(x_coord - 1, y_coord - 1)
  unless coord
    puts message(:not_available, x: x_coord, y: y_coord)
    next
  end

  if coord.intact?
    board.find_coord(coord.x, coord.y).damage
    board2.find_coord(coord.x, coord.y).damage
  end

  if coord.empty?
    board.find_coord(coord.x, coord.y).damage
    board2.find_coord(coord.x, coord.y).bypass
  end
end

puts "GAME OVER!"
