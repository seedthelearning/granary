require 'spec_helper'

describe "Participant" do
  describe "#origin_link" do
    it "returns the origin link" do
      link = "http://foo.com"
      seed = double(:seed, :link => link)

      participant = Participant.new
      participant.stub(:origin).and_return(seed)
      participant.origin_link.should eq(link)
    end
  end

  describe ".create_with_origin" do
  	context "a valid origin seed" do

      let(:seed) { Seed.new }

      before(:each) do
        Participant.stub(:create).and_return(Participant.new)
      end

      it "connects participant and seed via origin" do
        participant = Participant.create_with_origin(seed)
        participant.origin.should eq(seed)
      end

      it "connects seed and participant via helper" do
        participant = Participant.create_with_origin(seed)
        seed.helpers.include?(participant).should be_true
      end
  	end
  end
end