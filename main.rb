#! /usr/bin/env ruby

require "pry"
require "./board"
require "./ship"
require "./user"
require "./drawer"
require "./messages"

include Messages

# 1. Create board for the 1st User
board = Board.new(10, 10)
board.drawer = Drawer.new(:console, board) # Set the drawer
user = User.new(board)

# 2. Intro message
puts message(:intro)

# 3. Draw the board using drawer
board.draw

# 4. Choose the ships placement mode: manual or automatic
user.choose_mode
puts message(:placement_mode, mode: user.mode)

## BOARD #1: Place ships
puts "You have to build 10 ships to start the game..."
all_ships    = Ship.build_all_ships # 5. Pre build all ships
current_ship = all_ships.pop # 5.1 Pick first ship
while user.ships_left_to_build > 0
  puts "#{user.ships_left_to_build} ships left to build!"

  # 6. Manual/Auto input of coordinates
  coord = user.choose_next_coord(current_ship)

  # 7. Validate coordinate: not nil, empty, no ships around
  if coord && coord.available?(current_ship)
    current_ship << coord
    if current_ship.complete?
      user.ships << current_ship
      current_ship = all_ships.pop # 7.1 Pick next ship
    end
  else
    puts message(:not_available, x: coord.x, y: coord.y) if coord
    current_ship.destroy # 7.2 Destroy the ship if it is not valid
  end

  board.draw
end

## BOARD #2: Hit ships
board2 = Board.new(10, 10)
user2 = User.new(board2)
gtk_drawer = Drawer.new(:gtk3, board2, orig_board: board, user: user)
board2.drawer = gtk_drawer

board2.draw

puts "GAME OVER!"
