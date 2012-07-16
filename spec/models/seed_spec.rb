require 'spec_helper'

describe "Seed" do
  describe "#plant" do
    let(:link) { "http://foo.com" }

    context "given donation information" do
      before(:each) do
        
      end

      it "creates a seed with the correct link" do
        @seed = Seed.plant(link, 10000)
        @seed.link.should eq(link)
      end

      it "creates a seed with the correct donation" do
        donation = double(:donation, :amount_cents => 10000,
                          :payout_cents => 100)
        Donation.stub(:create).with(:amount_cents => 10000,
                                    :payout_cents => 100).
                                    and_return(donation)
        Neo4j::Rails::Relationships::NodesDSL.any_instance.should_receive(:<<).with(donation)                                     
        @seed = Seed.plant(link, 10000)
      end

    end

    context "given no donation information" do
      it "creates a seed with the correct link" do
        seed = Seed.plant(link, nil)
        seed.link.should eq(link)
      end
    end
  end
end