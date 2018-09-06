require 'minitest/autorun'
require 'minitest/pride'
require './lib/player'
require './lib/board'
require './lib/ship'


class PlayerTest < Minitest::Test

  def test_it_exists
    assert_instance_of Player, Player.new(true)
  end

  def test_it_gets_attributes
    p1 = Player.new(false)
    p2 = Player.new(false, [3, 3])
    human = Player.new(true)
    assert_equal false, p1.is_human
    assert_equal true, human.is_human
    assert_instance_of Board, p1.board
    assert_instance_of Board, human.board
    assert_equal [2, 3], p1.ships
    assert_equal [3, 3], p2.ships
  end

  def test_it_starts_game
    p1 = Player.new(false)
    p1.start_game
    assert_equal 16, p1.board.positions.count
  end

  def test_it_can_place_all_ships
    skip
  end
end
