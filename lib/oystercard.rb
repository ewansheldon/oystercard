require_relative 'journey'

class Oystercard

  attr_reader :balance, :journeys

  DEFAULT_LIMIT = 90
  DEFAULT_BALANCE = 0
  MINIMUM_FARE = 1

  def initialize(journey_log = JourneyLog.new)
    @journey_log = journey_log
    @balance = DEFAULT_BALANCE
  end

  def top_up(amount)
    fail 'Balance limit reached' if full? || amount > DEFAULT_LIMIT
    @balance += amount
    balance_confirmation
  end

  def touch_in(entry_station)
    fail 'Insufficient funds' if balance < MINIMUM_FARE
    @journey_log.start(entry_station)
  end

  def touch_out(exit_station)
    close_journey(exit_station)
    deduct(@journey_log.get_fare)
  end

  private

  def no_touch_in_penalty
      @journey_log.start('Unknown Station')
      @journey_log.add_penalty_fare
  end

  def no_touch_out_penalty
    @journey_log.penalty_fare
    @journey_log.finish('Unknown Station')
  end

  def close_journey(exit_station)
    @journey_log.finish(exit_station)
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

end
