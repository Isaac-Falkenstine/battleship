require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship'


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
  def test_it_can_anchor_ship
      board = Board.new(2)
      board.initialize_positions
      position1 = board.positions[:A1]
      position2 = board.positions[:A2]
      assert_nil position1[:player_map][:ship]
      assert_nil position2[:player_map][:ship]
      board.anchor_ship(["A1", "A2"])
      assert_instance_of Ship, position1[:player_map][:ship]
      assert_instance_of Ship, position2[:player_map][:ship]
      assert_equal ["A1", "A2"], position1[:player_map][:ship].coordinates
  end

  def test_it_can_update_player_map_with_enemy_shots
    board = Board.new(2)
    positions = board.positions
    board.initialize_positions
    assert_equal false, positions[:A1][:player_map][:shot]
    board.anchor_ship(["A1"])
    board.update_player_map("A1")
    assert_equal true, positions[:A1][:player_map][:shot]
    assert_equal true, positions[:A1][:player_map][:hit]
  end

  def test_it_can_update_actualizations_of_enemy_map
    board = Board.new(2)
    positions = board.positions
    board.initialize_positions
    assert_equal false, positions[:A1][:enemy_map][:shot]
    board.update_enemy_map("A1", false)
    assert_equal true, positions[:A1][:enemy_map][:shot]
    assert_equal false, positions[:A1][:enemy_map][:hit]
    board.update_enemy_map("A1", true)
    assert_equal true, positions[:A1][:enemy_map][:shot]
    assert_equal true, positions[:A1][:enemy_map][:hit]
  end

  def test_it_can_create_possible_positions_for_a_ship
    board = Board.new
    board.initialize_positions

    choices_for_2 = board.possible_positions(2)
    assert_equal 2, choices_for_2[0].count
    assert_equal 3*4*2, choices_for_2.count

    choices_for_3 = board.possible_positions(3)
    assert_equal 3, choices_for_3[0].count
    assert_equal 2*4*2, choices_for_3.count
    board.anchor_ship(["A1", "A2"])
    choices_for_3 = board.possible_positions(3)
    assert_equal (2*4*2)-4, choices_for_3.count
  end

  def test_it_can_prevent_ship_overlap
    board = Board.new
    board.initialize_positions
    no_nil = board.prevent_overlap
    actual = no_nil.any? { |set| set.include?(nil) }
    assert_equal false, actual
    board.anchor_ship(["A1", "A2"])
    with_nil = board.prevent_overlap
    actual = with_nil.any? { |set| set.include?(nil) }
    assert_equal true, actual
  end

  def test_it_can_collect_sets
    board = Board.new(2)
    arr = [["A1", "A2"], ["B1", "B2"]]
    sets = board.collect_sets(arr, 2)
    assert_equal 4, sets.count
  end

  def test_it_can_loop_through_rows
    board = Board.new(2)
    arr = [["A1", "A2"], ["B1", "B2"]]
    sets = board.loop_through_rows_for_sets(arr, 2)
    assert_equal 2, sets.count
  end

  def test_it_can_identify_sets_by_row
    board = Board.new(2)
    row = ["A1", "A2"]
    sets = board.identify_sets_by_row(row, 2, sets = [])
    assert_equal 1, sets.count
  end

  def test_it_can_print_the_board
    board = Board.new
    board.initialize_positions
    assert_equal String, board.print_board(:player_map).class
    assert_equal String, board.print_board(:enemy_map).class
    assert_equal false, board.print_board(:enemy_map).include?("#")
    board.anchor_ship(["A1", "A2"])
    assert_equal String, board.print_board(:player_map).class
    assert_equal true, board.print_board(:player_map).include?("#")
  end

  def test_it_can_assign_board_visuals
    board = Board.new(2)
    board.initialize_positions
    board.anchor_ship(["A1", "A2"])
    board.update_player_map("A1")
    board.update_player_map("B1")
    player_middle = ["H", "#", "M", " "]
    assert_equal player_middle, board.assign_board(:player_map)
    board.update_enemy_map("A1", true)
    board.update_enemy_map("B1", false)
    enemy_middle = ["H", " ", "M", " "]
    assert_equal enemy_middle, board.assign_board(:enemy_map)
  end
end
