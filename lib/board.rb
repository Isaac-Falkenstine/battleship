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

  def collect_sets(arr, width)
    sets1 = loop_through_rows_for_sets(arr, width)
    sets2 = loop_through_rows_for_sets(arr.transpose, width)
    sets = sets1 + sets2
    sets = sets.flatten!.each_slice(width).to_a
  end

  def loop_through_rows_for_sets(array, width)
    array.map { |row| identify_sets_by_row(row, width) }
  end

  def identify_sets_by_row(row, width, sets = [])
    return sets if row.size < width
    sets << [row.first(width)]
    head, *tail = row
    identify_sets_by_row(tail, width, sets)
  end


  def print_board(map_sym)
    arr = assign_board(map_sym).each_slice(@size).to_a
    arr = build_rows(arr)
    arr = arr.unshift(build_header)
    string = build_string(arr)
    return string
  end


  def assign_board(map_sym)
    arr = create_positions
    arr.each.with_index { |pos, i|
        position = @positions[pos.to_sym][map_sym]
        arr[i] = get_char(position)
    }
    return arr
  end

  def get_char(position)
    return "H" if position[:hit] == true
    return "M" if position[:shot] == true
    return "#" if position[:ship] != nil
    return " "
  end

  def build_rows(array)
    rows = self.rows
    array.map.with_index { |row, i|
      row.unshift(rows[i])
      row.insert(-1, "\n" )
    }
  end

  def build_header
    row = self.columns
    row.unshift(".")
    row.insert(-1, "\n")
    return row
  end

  def build_string(arr)
    prestring = arr.map { |row| row.join(" ")}
    string = prestring.join
    frame = "===========\n"
    print "\n" + frame + string + frame
    return string
  end

  def moves_so_far(winner)
    winner = "player" ? map_sym = :enemy_map : map_sym = :player_map
    @positions.count {|key, val|
      @positions[key][map_sym][:shot] == true
    }
  end

  def player_moves_to_win
    remaining_targets(:enemy_map)
  end

  def enemy_moves_to_win
    remaining_targets(:player_map)
  end

  def remaining_targets(map_sym)
    total = find_all_player_ship_coordinates.count
    hits = critically_hit(map_sym).count
    remaining = total - hits
  end

  def critically_hit(map_sym)
    @positions.find_all {|key, val|
      @positions[key][map_sym][:hit] == true
    }.to_h
  end

  def find_all_player_ship_coordinates
    @positions.find_all {|key, val|
      @positions[key][:player_map][:ship] != nil
    }.to_h
  end
end
