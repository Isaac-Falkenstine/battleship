require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'


class BoardTest < Minitest::Test

  def test_it_exists
    assert_instance_of Board, Board.new
  end

  def test_it_gets_default_values_or_replaces_and_gets_value
    default = Board.new

    assert_equal 4, default.size
    empty = {}

    assert_equal empty, default.positions

    assigned = Board.new(6)

    assert_equal 6, assigned.size
  end

  def test_it_creates_row_headers
    default = Board.new
    expected = ["A", "B", "C", "D"]
    assert_equal expected, default.rows

    assigned = Board.new(2)
    expected = ["A", "B"]
    assert_equal expected, assigned.rows
  end

  def test_it_creates_column_headers
    default = Board.new
    expected = [1, 2, 3, 4]
    assert_equal expected, default.columns

    assigned = Board.new(2)
    expected = [1, 2]
    assert_equal expected, assigned.columns
  end

  def test_it_creates_position_labels
  default = Board.new
  expected = [
    "A1", "A2", "A3", "A4",
    "B1", "B2", "B3", "B4",
    "C1", "C2", "C3", "C4",
    "D1", "D2", "D3", "D4"
  ]
  assert_equal expected, default.create_positions

  assigned = Board.new(2)
  expected = [
    "A1", "A2",
    "B1", "B2"
  ]
  assert_equal expected, assigned.create_positions
end

def test_it_can_initialize_positions_with_default_states
  board = Board.new(2)
  positions = board.positions
  assert_equal empty = {}, positions
  board.initialize_positions

  assert_equal false, positions[:A1][:player_map][:shot]
  assert_equal false, positions[:A1][:player_map][:hit]
  assert_equal nil,   positions[:A1][:player_map][:ship]
  assert_equal false, positions[:A1][:enemy_map][:shot]
  assert_equal false, positions[:A1][:enemy_map][:hit]

  assert_equal false, positions[:A2][:player_map][:shot]
  assert_equal nil,   positions[:B1][:player_map][:ship]
  assert_equal false, positions[:B2][:enemy_map][:hit]
end

end
