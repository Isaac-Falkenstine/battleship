require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'


class ShipTest < Minitest::Test

  def test_it_exists
    assert_instance_of Ship, Ship.new(["A1", "A2"])
  end

  def test_it_gets_attributes_and_default_values
    ship = Ship.new(["A1", "A2"])
    assert_equal ["A1", "A2"], ship.coordinates
    empty = {}
    assert_equal empty, ship.status
  end

  def test_it_can_initialize_the_status_hash
    ship = Ship.new(["A1", "A2"])
    ship.initialize_status
    expected = {A1: false, A2: false}
    assert_equal expected, ship.status
  end

  def test_it_can_update_status_if_hit
    ship = Ship.new(["A1", "A2"])
    ship.initialize_status
    expected = {A1: false, A2: false}
    assert_equal expected, ship.status
    ship.update_status("A1")
    expected = {A1: true, A2: false}
    assert_equal expected, ship.status
    ship.update_status("A2")
    expected = {A1: true, A2: true}
    assert_equal expected, ship.status
  end

  def test_it_can_count_the_remaining_hits_to_sink_ship
    ship = Ship.new(["A1", "A2"])
    ship.initialize_status
    assert_equal 2, ship.remaining_hits
    ship.update_status("A1")
    assert_equal 1, ship.remaining_hits
    ship.update_status("A2")
    assert_equal 0, ship.remaining_hits
  end
end
