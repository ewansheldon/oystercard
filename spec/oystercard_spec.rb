require 'oystercard'

describe Oystercard do
  let(:receipt) {{entry: entry_station, exit: exit_station, fare: Journey::MINIMUM_FARE}}
  let(:journey)  {spy('Journey', :fare => 1, :receipt => receipt )}
  subject(:oystercard) {described_class.new(journey)}

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  describe '#initialize' do
    it 'instantiates with a balance of 0' do
      expect(oystercard.balance).to eq described_class::DEFAULT_BALANCE
    end

    it 'raises an error when instantiated balance is larger than limit' do
      msg = 'Balance limit reached'
      expect {oystercard.top_up(100)}.to raise_error msg
    end

    it 'has an empty list of journeys by default' do
      expect(oystercard.journeys).to be_empty
    end

  end

  describe '#top_up' do

    it 'confirms new balance after top-up' do
      msg = "Your new balance is 10"
      expect(oystercard.top_up(10)).to eq msg
    end

    it 'updates the balance' do
      oystercard.top_up(10)
      expect(oystercard.balance).to eq 10
    end

    it 'raises error if limit reached' do
      oystercard.top_up(90)
      msg = 'Balance limit reached'
      expect {oystercard.top_up(1)}.to raise_error msg
    end
  end

  describe '#touch_in' do

    it 'will not touch in if insufficient funds' do
      msg = 'Insufficient funds'
      expect { oystercard.touch_in(entry_station) }.to raise_error msg
    end

    context 'dealing with penalty fares' do

      it 'adds penalty fare on double touch in' do
        oystercard.top_up(50)
        oystercard.touch_in('Station1')
        expect(oystercard.instance_variable_get(:@journey)).to receive(:add_penalty_fare)
        oystercard.touch_in('Station2')
      end

    end

  end

  describe '#touch_out' do
    before do
      oystercard.top_up(50)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
    end

    it 'will deduct fare amount from card balance' do
      expect(oystercard.balance).to eq 49
    end

    it 'will forget the journey  after touch out' do
      expect(oystercard.instance_variable_get(:@journey)).to be_nil
    end

    it 'stores a journey' do
      expect(oystercard.journeys).to eq([journey])
    end

    context 'dealing with penalty fares' do
      let(:journey)  {spy('Journey', :complete => true, :add_penalty_fare => 6, :fare => 7 )}
      subject(:oystercard) {described_class.new(journey)}

      it 'adds penalty fare on touch out w/o touch in' do
        expect{oystercard.touch_out('Station1')}.to change{oystercard.balance}.by(-7)
      end

    end

  end
end
