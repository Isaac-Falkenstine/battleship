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
end
