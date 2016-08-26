class JourneyLog

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
  end

  def start(entry_station)
    @current_journey = @journey_class.new(entry_station)
  end

end
