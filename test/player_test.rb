require 'simplecov'
SimpleCov.start
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
    person = Player.new(true)

    assert_equal false, p1.is_human
    assert_equal true, person.is_human
    assert_instance_of Board, p1.board
    assert_instance_of Board, person.board
    assert_equal [2, 3], p1.ships
    assert_equal [3, 3], p2.ships
  end

  def test_it_starts_game
    p1 = Player.new(false)
    p1.start_game
    assert_equal 16, p1.board.positions.count
  end

  def test_it_can_process_input_coordinates
    human = Player.new(true)
    arr = human.process_coordinates("A1 A2")
    assert_equal ["A1", "A2"], arr
  end

  def test_it_can_do_a_random_shot
    p1 = Player.new(false)
    p1.start_game
    coord = p1.random_shot
    positions = p1.board.positions.keys
    actual = positions.include?(coord)
    assert_equal true, actual
    assert_equal 1, [coord].flatten.count
  end

  def test_it_can_assess_format_of_ship_placement
    person = Player.new(true)

    valid = ["A1 A2", "A1-A2", "A1*A2"]

    invalid_case = "a1 a2"
    invalid_size = [" ", "A1", "A1A2", " A1 A2 "]
    invalid_form = ["A1A2 ", " A1A2",]
    invalid_content = ["AAAAA", "11111", "A1234", "123A1"]

    all_valid = valid.all? { |input| person.assess_format(input) }
    assert_equal true, all_valid

    assert_equal false, person.assess_format(invalid_case)

    all_invalid_size = invalid_size.all? { |input| person.assess_format(input) == false }
    assert_equal true, all_invalid_size

    all_invalid_form = invalid_form.all? { |input| person.assess_format(input) == false }
    assert_equal true, all_invalid_form

    all_invalid_content = invalid_content.all? { |input| person.assess_format(input) == false }
    assert_equal true, all_invalid_content
  end

  def test_it_can_assess_diagonal_placement
    person = Player.new(true)
    valid = "A1 B1"
    invalid = "A1 B2"
    assert_equal true, person.assess_diagonal(valid)
    assert_equal false, person.assess_diagonal(invalid)
  end

  def test_it_can_assess_space_between_coordinates
    person = Player.new(true)
    valid_1 = "A1 B1"
    valid_2 = "B1 B2"
    invalid_1 = "A1 A3"
    invalid_2 = "A1 A1"
    invalid_3 = "A1 C1"
    invalid_4 = "A2 A1"

    assert_equal true, person.assess_spacing(valid_1, 2)
    assert_equal true, person.assess_spacing(valid_2, 2)
    assert_equal true, person.assess_spacing(valid_2, 2)
    assert_equal false, person.assess_spacing(invalid_1, 2)
    assert_equal false, person.assess_spacing(invalid_2, 2)
    assert_equal false, person.assess_spacing(invalid_3, 2)
    assert_equal false, person.assess_spacing(invalid_4, 2)
  end
end
