require 'spec_helper'

describe "/api/v1/trees", :type => :api do
  describe "#show" do
    context "seed has no children" do
      it "returns json with no children" do
        seed = double(:seed, :id => 1, :link => "http://foo.com", :reseeds => [])
        seed.stub(:tree).and_return({:children => {}})
        Seed.stub(:find).and_return(seed)
        get "api/v1/trees/1.json"
        response = JSON.parse(last_response.body)
        response["children"].should eq({})
      end
    end

    context "seed has children" do
      it "returns json with children" do
        seed_two = double(:seed, :id => 2, :link => "http://foo2.com", :reseeds => [])
        seed = double(:seed, :id => 1, :link => "http://foo.com", :reseeds => [seed_two])
        seed.stub(:tree).and_return({1 => {:children => { 2 => {}}}})
        Seed.stub(:find).and_return(seed)
        get "api/v1/trees/1.json"
        response = JSON.parse(last_response.body)
        response["1"]["children"]["2"].should_not be_nil
      end
    end

    context "seed has grandchildren" do
      it "returns json with children"
    end

    context "given a bad seed" do
      before(:each) do
        get "api/v1/trees/adf.json"
      end

      it "returns a 404 not found" do
        last_response.status.should eq(404)
      end

      it "returns an error message" do
        response = JSON.parse(last_response.body)
        response["error"].should_not be_nil
      end
    end
  end
end
