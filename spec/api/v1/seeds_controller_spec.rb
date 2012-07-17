

require 'spec_helper'

describe "/api/v1/seeds", :type => :api do

  describe "#create" do
    context "new seed" do
      let(:amount) { 10000 }
      let(:link) { "http://foo.com" }
      let(:donation) { double(:donation, amount_cents: amount, payout_cents: 100) }
      before(:each) do
        seed = double(:seed, :id => 1, :link => link)
        Seed.stub(:plant).and_return(seed)
        seed.stub(:pledge).and_return(donation)
        post "api/v1/seeds.json", :body => { :amount_cents => amount }
      end

      it "returns a 201 Created" do
        last_response.status.should == 201
      end

      it "returns a json response with a seed" do
        json_response = JSON.parse(last_response.body)
        json_response["link"].should eq(link)
      end

      it "returns a seed with an id" do
        json_response = JSON.parse(last_response.body)
        json_response["id"].should eq(1)
      end

      it "returns a seed with a donation" do
        json_response = JSON.parse(last_response.body)
        json_response["donation"]["amount_cents"].should eq(10000)
        json_response["donation"]["payout_cents"].should eq(100)
      end
    end

    context "reseed" do
      let(:amount) { 10000 }
      let(:link) { "http://foo.com" }
      let(:donation) { double(:donation, amount_cents: amount, payout_cents: 100) }
      before(:each) do
        seed = double(:seed, :id => 1, :link => link)
        Seed.stub(:reseed).and_return(seed)
        seed.stub(:pledge).and_return(donation)
        post "api/v1/seeds.json", :body => { :link => link, :amount_cents => amount }
      end

      it "returns a 201 Created" do
        last_response.status.should == 201
      end

      it "returns a seed with an id" do
        json_response = JSON.parse(last_response.body)
        json_response["id"].should eq(1)
      end

      it "returns a seed with a donation" do
        json_response = JSON.parse(last_response.body)
        json_response["donation"]["amount_cents"].should eq(10000)
        json_response["donation"]["payout_cents"].should eq(100)
      end
    end
  end

  describe "#show" do
    let(:url) { "api/v1/seeds/1.json" }
    context "seed doesn't have a donation" do

      context "seed exists" do
        let(:seed) { FactoryGirl.build(:seed, :link => "http://testtwo.com") }

        before(:each) do
          Seed.stub(:find).and_return(seed)
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
          Seed.stub(:find).and_return(nil)
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

    context "seed has donation" do
      let(:donation) { double(:donation, :amount_cents => 10000, :payout_cents => 100)}
      let(:seed) { FactoryGirl.build(:seed, :link => "http://testtwo.com") }

      before(:each) do
        Seed.stub(:find).and_return(seed)
        seed.stub(:id).and_return(1)
        seed.stub(:pledge).and_return(donation)
        get url
      end

      it "returns a 200 OK" do
        last_response.status.should eq(200)
      end

      it "returns the correct seed" do
        json_response = JSON.parse(last_response.body)
        json_response["link"].should eq("http://testtwo.com")
        json_response["id"].should eq(1)
      end

      it "returns a seed with the correct donation" do
        json_response = JSON.parse(last_response.body)
        json_response["donation"]["amount_cents"].should eq(10000)
        json_response["donation"]["payout_cents"].should eq(100)
      end

    end
  end

  describe "#index" do
    context "there are seeds" do
      context "there are no donations" do
        let(:seeds) { [ FactoryGirl.build(:seed, :link => "http://link1.com"),
          FactoryGirl.build(:seed, :link => "http://link2.com"),
          FactoryGirl.build(:seed, :link => "http://link3.com")] }
          before(:each) do
            Seed.stub(:all).and_return(seeds)
            seeds[0].stub(:id).and_return(1)
            seeds[1].stub(:id).and_return(2)
            seeds[2].stub(:id).and_return(3)
            Seed.any_instance.stub(:pledge).and_return(nil)
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

        context "there are donations" do

          let(:seeds) { [ FactoryGirl.build(:seed, :link => "http://link1.com"),
          FactoryGirl.build(:seed, :link => "http://link2.com"),
          FactoryGirl.build(:seed, :link => "http://link3.com")] }
          let(:donation) { double(:donation, amount_cents: 10000, payout_cents: 100) }
          
          before(:each) do
            Seed.stub(:all).and_return(seeds)
            seeds[0].stub(:id).and_return(1)
            seeds[1].stub(:id).and_return(2)
            seeds[2].stub(:id).and_return(3)
            seeds[0].stub(:pledge).and_return(donation)
            seeds[1].stub(:pledge).and_return(donation)
            seeds[2].stub(:pledge).and_return(donation)
          end

          it "returns the expected list of seeds with links" do
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

          it "returns the expected list of seeds with donations" do
            get "api/v1/seeds.json"
            json_response = JSON.parse(last_response.body)
            json_response[0]["donation"]["amount_cents"].should eq(10000)
            json_response[0]["donation"]["payout_cents"].should eq(100)
            json_response[1]["donation"]["amount_cents"].should eq(10000)
            json_response[1]["donation"]["payout_cents"].should eq(100)
            json_response[2]["donation"]["amount_cents"].should eq(10000)
            json_response[2]["donation"]["payout_cents"].should eq(100)
          end
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

    end
  end