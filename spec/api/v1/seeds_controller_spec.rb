require 'spec_helper'

describe "/api/v1/seeds", :type => :api do

  describe "#create" do
    context "seed without a donation" do
      context "seed doesn't exist" do
        let(:link) { "http//foo.com" }

        before(:each) do
          seed = FactoryGirl.build(:seed, :link => link)
          Seed.stub(:create).with(:link => link).and_return(seed)
          post "api/v1/seeds.json", :body => {:link => link}
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
      it "returns a 201 created"
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
end