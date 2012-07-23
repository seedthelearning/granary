require 'spec_helper'

describe "Seed" do
  describe "#reseed" do
    let(:link) { "http://foo.com" }

    context "given donation information" do
      it "the created seed is connected to another seed" do
        parent = double(:seed)
        child = double(:seed)
        reseeds = double(:reseeds)
        
        Seed.stub(:plant).with(10000).and_return(child)
        Seed.stub(:find).with(:link => link).and_return(parent)
        
        parent.stub(:outgoing).and_return(reseeds)
        reseeds.should_receive(:<<).with(child)                                    
        parent.should_receive(:save)     
        Seed.reseed(link, 10000)
      end
    end
  end

  describe "#plant" do
    let(:link) { "http://foo.com" }
    let(:amount) { 10000 }

    it "attaches a pledge" do
      Seed.stub(:generate_link).and_return(link)
      donation = double(:donation, amount_cents: amount)
      seed = double(:seed, link: link)
      Seed.stub(:create).with(:link => link).and_return(seed)
      Seed.stub(:create_donation).with(amount).and_return(donation)
      seed.should_receive(:pledge=).with(donation)
      seed.should_receive(:save)
      Seed.plant(amount)
    end

  end
end