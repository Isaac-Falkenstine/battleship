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
end
