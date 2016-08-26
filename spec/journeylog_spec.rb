require 'journeylog'

describe JourneyLog do

subject(:journeylog) {described_class.new(journey_class)}
let(:journey_class)  {double :journey_class, new: nil}

describe '#initialize' do

    it 'stores journey class' do
    expect(journeylog.instance_variable_get(:@journey_class)).to eq journey_class
    end

  end

end
