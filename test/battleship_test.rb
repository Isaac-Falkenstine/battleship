require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/battleship'
require 'pry'

class BattleshipTest < MiniTest::Test
  def test_it_exists
    battleship = Battleship.new
    assert_instance_of Battleship, battleship
  end
end
