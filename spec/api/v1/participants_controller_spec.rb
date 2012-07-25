require 'spec_helper'

describe "/api/v1/participants", :type => :api do

  describe "#create" do
    context "given a seed" do
      let(:link) { "http://foo.com" }

      before(:each) do
        url = "api/v1/participants.json"
        seed = double(:seed, :link => link, :id => 1, :user_id => 111)
        Seed.stub(:find).and_return(seed)
        seed.stub(:helper?).and_return(false)
        participant = double(:participant, :user_id => 111)
        Participant.stub(:create_with_origin).and_return(participant)
        participant.stub(:origin_link).and_return(link)
        
        post url, :body => { :link => link }
      end

      it "returns a 201 created" do
        last_response.status.should == 201
      end

      it "creates a participant" do
        json_response = JSON.parse(last_response.body)
        json_response["parent_seed_url"].should eq(link)
      end

      it "includes the user id" do
        json_response = JSON.parse(last_response.body)
        json_response["user_id"].should eq(111)
      end
    end

    context "given no seed" do
      it "returns a status 400" do
        Seed.stub(:find)
        post "api/v1/participants.json", :body => "" 
        last_response.status.should == 400
      end
    end
  end
end
