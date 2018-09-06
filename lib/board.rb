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


  def anchor_ship(coordinates)
      ship = Ship.new(coordinates)
      coordinates.each {|spot|
        key = spot.to_sym
        positions[key][:player_map][:ship] = ship
      }
  end

  def update_player_map(coord)
    position = @positions[coord.to_sym][:player_map]
    position[:shot] = true
    if position[:ship] != nil
      position[:hit] = true
      position[:ship].update_status(coord)
    end
  end

  def update_enemy_map(coord, success)
    position = @positions[coord.to_sym][:enemy_map]
    position[:shot] = true
    position[:hit] = true if success
  end
  # TO DO --- ADD successful_hit method
    # player or board???

  def possible_positions(width)
    arr = prevent_overlap
    sets = collect_sets(arr, width)
    sets.reject!{|set| set.include?(nil)}
    return sets
  end

  def collect_sets(arr, width)
    sets1 = loop_through_rows_for_sets(arr, width)
    sets2 = loop_through_rows_for_sets(arr.transpose, width)
    sets = sets1 + sets2
    sets = sets.flatten!.each_slice(width).to_a
  end

  def prevent_overlap
    arr = create_positions
    arr.each.with_index { |pos, i|
      key = pos.to_sym
      arr[i] = nil if @positions[key][:player_map][:ship]
    }
    return arr.each_slice(@size).to_a
  end
end
