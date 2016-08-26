require 'journeylog'

describe JourneyLog do

subject(:journeylog) {described_class.new(journey_class)}
let(:journey_class)  {double :journey_class, new: journey}
let(:journey)        {double :journey, complete: nil, fare: 1, add_penalty_fare: nil}
let(:entry_station)  {double :entry_station}
let(:exit_station)   {double :exit_station}

describe '#initialize' do

    it 'stores journey class' do
    expect(journeylog.instance_variable_get(:@journey_class)).to eq journey_class
    end

  end

  describe '#start' do
    it 'creates an instance of journey class' do
      journeylog.start(entry_station)
      expect(journey_class).to have_received(:new).with(entry_station)
    end

    it 'saves the current journey to instance variable' do
      journeylog.start(entry_station)
      expect(journeylog.instance_variable_get(:@current_journey)).to eq journey
    end
  end

  describe '#finish' do
    it 'calls complete on the journey instance' do
      journeylog.start(entry_station)
      journeylog.finish(exit_station)
      expect(journey).to have_received(:complete).with(exit_station)
    end


    it 'clears current journey' do
      journeylog.start(entry_station)
      journeylog.finish(exit_station)
      expect(journeylog.instance_variable_get(:@current_journey)).to be_nil
    end

    it 'saves completed journey' do
      journeylog.start(entry_station)
      journeylog.finish(exit_station)
      expect(journeylog.instance_variable_get(:@journey_history)).to eq [journey]
    end

  end

  describe '#penalty_fare' do
    it 'adds penalty fare penalities' do
      journeylog.finish(exit_station)
      expect(journeylog.instance_variable_get(:@penalties)).to eq described_class::PENALTY_FARE
    end
  end

end
