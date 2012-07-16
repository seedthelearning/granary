require 'spec_helper'

describe "/api/v1/seeds", :type => :api do

  describe "#create" do
    context "seed without a donation" do
      context "seed doesn't exist" do
        let(:link) { "http//foo.com" }

        before(:each) do
          seed = FactoryGirl.build(:seed, :link => link)
          Seed.stub(:create).with(:link => link).and_return(seed)
          post "api/v1/seeds.json", :body => {:link => link }
        end

        it "returns a 201 Created" do
          last_response.status.should == 201
        end

        it "returns a json response with the created seed" do
          json_response = JSON.parse(last_response.body)
          json_response["link"].should eq(link)
        end
      end
    end

    context "seed with a donation" do
      let(:link) { "http://foo.com" }

      before(:each) do
        seed = FactoryGirl.build(:seed, :link => link)
        donation = FactoryGirl.build(:donation, :amount_cents => 1000,
                                      :payout_cents => 100)
        Seed.stub(:create).with(:link =>link).and_return(seed)
        Donation.stub(:create).with(:link => link).and_return(donation)
        post "api/v1/seeds.json", :body => { :link => link }
        # Ideally I want to pass donation right with the seed creation... but how?
        # Alternative is that the controller accepting seed creation also sends call to api/v1/donations.json to create the donation.
        # Hold for consult.
      end

      it "returns a 200 OK" do
        pending "Discussion"
      end
      it "returns a json response with the created seed"
      it "returns a json response with the created donation"
    end
  end

  describe "#show" do
    let(:url) { "api/v1/seeds/1.json" }

    context "seed exists" do
      let(:seed) { FactoryGirl.build(:seed, :link => "http://testtwo.com") }
      
      before(:each) do
        Seed.stub(:find).with("1").and_return(seed)
        seed.stub(:id).and_return(1)
        get url
      end

      it "returns a 200 OK" do
        last_response.status.should == 200
      end

      it "returns a json response with the correct seed" do
        json_response = JSON.parse(last_response.body)
        json_response["link"].should eq("http://testtwo.com")
        json_response["id"].should eq(1)
      end
    end

    context "seed does not exist" do
      before(:each) do
        Seed.stub(:find).with("1").and_return(nil)
        get url
      end

      it "returns a 404 not found" do
        last_response.status.should eq(404)
      end

      it "returns an error message" do
        json_response = JSON.parse(last_response.body)
        json_response["error"].should eq("Seed not found")
      end
    end
  end

  describe "#index" do
    context "there are items" do
      let(:seeds) { [ FactoryGirl.build(:seed, :link => "http://link1.com"),
                      FactoryGirl.build(:seed, :link => "http://link2.com"),
                      FactoryGirl.build(:seed, :link => "http://link3.com")] }
      before(:each) do
        Seed.stub(:all).and_return(seeds)
        seeds[0].stub(:id).and_return(1)
        seeds[1].stub(:id).and_return(2)
        seeds[2].stub(:id).and_return(3)
      end

      it "returns the expected list of items with links" do
        get "api/v1/seeds.json"
        json_response = JSON.parse(last_response.body)
        json_response[0]["link"].should eq("http://link1.com")
        json_response[1]["link"].should eq("http://link2.com")
        json_response[2]["link"].should eq("http://link3.com")
      end

      it "returns the expected list of items with ids" do
        get "api/v1/seeds.json"
        json_response = JSON.parse(last_response.body)
        json_response[0]["id"].should eq(1)
        json_response[1]["id"].should eq(2)
        json_response[2]["id"].should eq(3)
      end
    end

    context "there are no items" do
      before(:each) do
        Seed.stub(:all).and_return(nil)
      end

      it "returns an empty list" do
        get "api/v1/seeds.json"
        json_response = JSON.parse(last_response.body)
        json_response.should eq([])
      end
    end

    # ALSO: TEST CREATING SEEDS WITH DONATIONS
  end
end