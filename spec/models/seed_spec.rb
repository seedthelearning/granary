require 'spec_helper'

describe "Seed" do
  let(:link) { "http://foo.com" }
  let(:amount) { 10000 }
  let(:user_id) { 100 }
  
  describe "#helper?" do
    let(:seed) { Seed.plant(1, 3000) }

    before(:each) do
      Participant.create_with_origin(seed, 2)
    end

    context "user is not yet a helper for this seed" do  
      it "returns false" do
        seed.helper?(3).should be_false
      end
    end

    context "user is a helper for this seed" do
      it "returns true" do
        seed.helper?(2).should be_true
      end
    end
  end

  describe "#total_donated" do
    it "returns the total donated" do
      seed = Seed.new
      mock_donation = double(:donation, :payout_cents => 100)
      seed.stub(:children_count).and_return(2)
      seed.stub(:pledge).and_return(mock_donation)
      seed.total_donated.should eq(200)
    end
  end

  describe "#children_count" do
    context "given a valid seed with helpers" do
      it "returns the correct number of children" do
        seed = Seed.create
        expect { Participant.create_with_origin(seed, 1) }.to change{ seed.children_count}.from(0).to(1)
      end
    end

    context "given a valid seed with no helpers" do
      it "returns 0" do
        seed = Seed.create
        seed.children_count.should eq(0)
      end
    end
  end

  describe "#reseed" do
    context "given donation information" do
      it "the created seed is connected to another seed" do
        parent = double(:seed)
        child = double(:seed)
        reseeds = double(:reseeds)
        
        Seed.should_receive(:plant).with(user_id, 10000).and_return(child)
        Seed.should_receive(:find).with(:link => link).and_return(parent)
        
        parent.stub(:outgoing).and_return(reseeds)
        reseeds.should_receive(:<<).with(child)                                    
        parent.should_receive(:save)     
        Seed.reseed(user_id, link, 10000)
      end
    end
  end

  describe "#plant" do
    it "attaches a pledge" do
      Seed.stub(:generate_link).and_return(link)
      donation = double(:donation, amount_cents: amount)
      seed = double(:seed, link: link)
      Seed.stub(:create).with(:user_id => user_id, :link => link).and_return(seed)
      Seed.stub(:create_donation).with(amount).and_return(donation)
      seed.should_receive(:pledge=).with(donation)
      seed.should_receive(:save)
      Seed.plant(user_id, amount)
    end

  end
end