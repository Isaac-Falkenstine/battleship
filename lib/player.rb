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
end
