require_relative 'journey'

class JourneyLog

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
    @journey_history = []
  end

  def start(entry_station)
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    @current_journey.complete(exit_station)
    @journey_history << @current_journey
    @current_journey = nil
  end

end
