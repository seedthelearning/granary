require 'spec_helper'

describe "/api/v1/seeds", :type => :api do

  describe "#create" do
    context "seed without a donation" do
      context "seed doesn't exist" do
        it "returns a 201 Created" do
          post "api/v1/seeds.json", :body => { :link => "http://foo.com" }
          last_response.status.should == 201
        end

        it "returns a json response with the created seed" do
          link = "http//foo.com"
          seed = FactoryGirl.build(:seed, :link => link)
          Seed.stub(:create).with(:link => link).and_return(seed)

          post "api/v1/seeds.json", :body => {:link => link}
          json_response = JSON.parse(last_response.body)
          json_response["seed"]["link"].should eq(link)
        end
      end

      context "seed exists" do
        pending "Not sure how we'd create/identify a duplicate seed"
      end
    end

    context "seed with a donation" do
      it "returns a 201 created"
      it "returns a json response with the created seed"
      it "returns a json response with the created donation"
    end
  end

  describe "#show" do
    context "seed exists" do
      it "returns a 200 OK" do
        seed = FactoryGirl.build(:seed)
        Seed.stub(:find).with("1").and_return(seed)

        get "api/v1/seeds/1.json" 
        last_response.status.should == 200
      end

      it "returns a json response with the correct seed" do
        seed = FactoryGirl.build(:seed, :link => "http://testtwo.com")
        Seed.stub(:find).with("1").and_return(seed)
        seed.stub(:id).and_return(1)

        get "api/v1/seeds/1.json"
        json_response = JSON.parse(last_response.body)
        json_response["link"].should eq("http://testtwo.com")
        json_response["id"].should eq(1)
      end
    end

    context "seed does not exist" do

    end
  end
end

class Foo; include Rack::Test::Methods; def app; Rails.application; end; end
