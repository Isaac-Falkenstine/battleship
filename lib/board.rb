class Board

  attr_reader :size, :positions

  def initialize(size = 4)
    @size = size
    @positions = {}
  end

  def rows
    alpha = ('A'..'Z').to_a
    alpha.first(@size)
  end

  def columns
    (1..@size).to_a
  end
  def create_positions
    pos = self.columns.map { |num|
      self.rows.map { |char| [char, num].join }
    }.flatten.sort
    return pos
  end

  def initialize_positions
    create_positions.each {|pos|
      @positions[pos.to_sym] = {
        :player_map => {shot: false, hit: false, ship: nil},
        :enemy_map  => {shot: false, hit: false}
      }
    }
  end
end
