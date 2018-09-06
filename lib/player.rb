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

  def validate_ship_placement(string, size)
    pick_random if string == "random"
    form = assess_format(string)
    grid = assess_diagonal(string)
    space = assess_spacing(string, size)
    possible = assess_as_possible(string)
    return true if form && grid && space && possible
  end

  def assess_format(string)
    case1 = string.size == 5
    arr = @board.create_positions
    case2 = string[0,1] != string[4,5]
    case3 = arr.include?(string[0..1])
    case4 = arr.include?(string[3..4])
    return true if case1 && case2 && case3 && case4
    p "Check your format!\nsize 2: A1 A2\nsize 3: A1 A3"
    return false
  end

  def assess_diagonal(string)
    arr = process_coordinates(string)
    row_1 = arr[0][0]; column_1 = arr[0][1]
    row_2 = arr[1][0]; column_2 = arr[1][1]
    case1 = row_1 == row_2
    case2 = column_1 == column_2
    return true if case1 || case2
    p "You can't place a boat diagonally."
    return false
  end
  def assess_spacing(string, size)
    arr = process_coordinates(string).join.chars
    columns = (arr[1]..arr[3]).to_a.size
    rows = (arr[0]..arr[2]).to_a.size
    case1 = columns == size && rows == 1
    case2 = rows == size && columns == 1
    return true if case1 || case2
    p "You're placing a boat with #{size} anchors"
    return false
  end

  def assess_as_possible(string)
    arr = process_coordinates(string)
    possible = @board.possible_positions
    possible.find {|set| set.first == arr.first && set.last == arr.last}
  end
end
