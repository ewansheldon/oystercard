require 'journey'

describe Journey do

subject(:journey) {described_class.new("station")}

  context 'when created' do

    it 'instantiates with an entry station' do
      expect(journey.instance_variable_get(:@entry_station)).to eq "station"
    end

    it 'instantiates with no exit station' do
      expect(journey.instance_variable_get(:@exit_station)).to be_nil
    end

    it 'instantiates with the custom minimum fare' do
      expect(journey.fare).to eq Journey::MINIMUM_FARE
    end

  end

  context 'when journey finished' do

    before do
      journey.complete("station2")
    end

    it 'retains the entry station' do
    expect(journey.instance_variable_get(:@entry_station)).to eq "station"
    end

    it 'updates exit station' do
      expect(journey.instance_variable_get(:@exit_station)).to eq "station2"
    end

    it 'expects minimum fare to remain the same' do
      expect(journey.fare).to eq Journey::MINIMUM_FARE
    end
  end

  context 'dealing with penalty fares' do
    it 'adds penalty_fare to fare'do
      journey.add_penalty_fare
      expect(journey.fare).to eq (Journey::MINIMUM_FARE + Journey::PENALTY_FARE)
    end
  end

end
