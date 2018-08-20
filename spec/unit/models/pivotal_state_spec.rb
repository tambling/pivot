require 'spec_helper'

RSpec.describe Pivot::PivotalState do
  describe '.closure_threshold' do
    after(:each) do
      Pivot::PivotalState.closure_threshold = 'finished'

    end

    it "returns 'finished' by default" do
      expect(Pivot::PivotalState.closure_threshold).to eq('finished')
    end

    it "can be set to a valid state" do
      threshold = 'started'
      Pivot::PivotalState.closure_threshold = threshold

      expect(Pivot::PivotalState.closure_threshold).to eq(threshold)
    end

    it "can't be set to an invalid state" do
      expect{ Pivot::PivotalState.closure_threshold = 'scoffed' }.
        to raise_error(InvalidClosureThresholdError)
    end
  end

  describe '#closed?' do
    it 'returns false if the state is before the closure threshold' do
      expect(Pivot::PivotalState.new('started').closed?).to be(false)
    end

    it 'returns true if the state is or is after the closure threshold' do
      expect(Pivot::PivotalState.new('finished').closed?).to be(true)
    end
  end
end
