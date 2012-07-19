require 'spec_helper'

describe "/api/v1/trees", :type => :api do
	describe "#show" do
    context "seed has no children" do
      it "returns a json seed" do

      end
      it "returns json with no children" do
        seed = double(:seed, :id => 1, :link => "http://foo.com", :reseeds => [])
        Seed.stub(:find).and_return(seed)
        get "api/v1/trees/1.json"
        response = JSON.parse(last_response.body)
        response["children"].should eq([])
      end
    end

    context "seed has children" do
      it "returns json with children" do
        seed_two = double(:seed, :id => 2, :link => "http://foo2.com", :reseeds => [])
        seed = double(:seed, :id => 1, :link => "http://foo.com", :reseeds => [seed_two])
        Seed.stub(:find).and_return(seed)
        get "api/v1/trees/1.json"
        response = JSON.parse(last_response.body)
        response["children"].first["id"].should eq(2)
      end
    end

    context "seed has grandchildren" do
      it "returns json with children"
    end

    context "given a bad seed" do
    	before(:each) do
        get "api/v1/trees/1.json"
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

# Find the root seed via the link
# Get all helpers of root seed
# Get all reseeds of root seed

# { id: 1, link: foo.com, type: seed,
#           children: [ { id: 2, link: foo, type: seed }, { id: 2, link: foo, type: seed }, { id: 3, type: participant } ]
# }

# { id: 1, link: foo.com, type: seed,
#   reseeds: [ { id: 2, link: foo, origin: 1}, 
#              { id: 3, link: foo, origin: 2 } ]
#   participants: [ { id: 10, origin: 2}, { id: 11, origin: 2} ]
# }
 