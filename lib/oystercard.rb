require_relative 'journey'

class Oystercard

  attr_reader :balance, :journeys

  DEFAULT_LIMIT = 90
  DEFAULT_BALANCE = 0
  MINIMUM_FARE = 1

  def initialize(journey_class = Journey)
    @journey = nil
    @journey_class = journey_class
    @journeys = []
    @balance = DEFAULT_BALANCE
  end

  def top_up(amount)
    fail 'Balance limit reached' if full? || amount > DEFAULT_LIMIT
    @balance += amount
    balance_confirmation
  end

  def touch_in(station)
    fail 'Insufficient funds' if balance < MINIMUM_FARE
    no_touch_out_penalty unless @journey.nil?
    @journey = @journey_class.new(station)
  end

  def touch_out(station)
    no_touch_in_penalty if @journey.nil?
    close_journey(station)
  end

  private

  def no_touch_in_penalty
      @journey = @journey_class.new('Unknown Station')
      @journey.add_penalty_fare
  end

  def no_touch_out_penalty
    @journey.add_penalty_fare
    close_journey('Unknown Station')
  end

  def close_journey(station)
    @journey.complete(station)
    deduct(@journey.fare)
    record_journey
    @journey = nil
  end

  def full?
    balance >= DEFAULT_LIMIT
  end

  def balance_confirmation
    "Your new balance is #{balance}"
  end

  def deduct(amount)
    fail 'Insufficient funds' if amount > balance
    @balance -= amount
    balance_confirmation
  end

  def record_journey
    @journeys << @journey
  end

end
