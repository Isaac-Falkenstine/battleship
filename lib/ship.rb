require 'pry'

class Ship

  attr_reader :coordinates, :status

  def initialize(coordinates)
    @coordinates = coordinates
    @status = {}
  end

  def initialize_status
    @coordinates.each { |coord|
      key = coord.to_sym
      @status[key] = false
    }
  end

  def update_status(position)
    key = position.to_sym
    @status[key] = true
  end

  def remaining_hits
    @status.values.count { |val| val == false }
  end
end
