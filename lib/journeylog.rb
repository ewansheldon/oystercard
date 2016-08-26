require_relative 'journey'

class JourneyLog

  PENALTY_FARE = 6

  attr_reader :current_journey, :journey_history, :penalties

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
    @journey_history = []
    @penalties = 0
    @outstanding_charges = 0
  end

  def start(entry_station)
    no_touch_out_penalty unless current_journey.nil?
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    no_touch_in_penalty if current_journey.nil?
    current_journey.complete(exit_station)
    journey_history << current_journey
    @outstanding_charges += current_journey.fare
    @current_journey = nil
  end

  def no_touch_out_penalty
    @outstanding_charges += PENALTY_FARE
    finish('Unknown Station')
  end

  def no_touch_in_penalty
    start('Unknown Station')
    @outstanding_charges += PENALTY_FARE
  end

  def get_fare
    x = @outstanding_charges
    @outstanding_charges = 0
    x
  end

end
