require 'pry'
require './lib/board'
require './lib/ship'


class Player
  attr_reader :is_human, :board, :ships

  def initialize(human, ships = [2,3])
    @is_human = human
    @board = Board.new
    @ships = ships
  end

  def start_game
    @board.initialize_positions
  end

  def place_ships
    @ships.each { |size|
      coordinates = prompt_user
      @board.anchor_ship(coordnates)
    }
  end

  def process_coordinates(string)
    [ string[0..1], string[3..4] ]
  end

  def placement_type
    @is_human ? human_place_ships : computer_place_ships
  end

  def computer_place_ships
    @ships.each { |size|
      coordinates = possible_positions(size).shuffle!.pop
      place_ship(coordnates)
    }
    pc_pass_turn
  end

  def pc_pass_turn
    p "I have laid out my ships on the grid."
    p "You now need to layout your two ships."
    p "The first is two units long and the"
    p "second is three units long."
    p "The grid has A1 at the top left and D4 at the bottom right."
    p ""
    p "Enter the squares for the two-unit ship:"
    return
  end

  def random_shot
    positions = @board.positions
    available = positions.find_all { |key, val|
      positions[key][:player_map][:shot] == false
    }.to_h.keys.shuffle!
    available.pop
  end
end
