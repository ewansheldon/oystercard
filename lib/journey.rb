class Journey

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :fare

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
    @fare = MINIMUM_FARE
  end

  def complete(exit_station)
    @exit_station = exit_station
  end

end
