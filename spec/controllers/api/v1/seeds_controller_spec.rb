require 'spec_helper'

describe Api::V1::SeedsController, :type => :api do
# describe "/api/v1/seeds", :type => :api do

describe "#create" do
  context "seed without a donation" do
    context "seed doesn't exist" do
      it "returns a 201 Created" do
        response = get :create, :body => { :link => "http://foo.com" }
        response.status.should == 201
      end

      it "returns a json response with the created seed" do
        link = "http//foo.com"
        seed = FactoryGirl.build(:seed,:link => link)
        Seed.stub(:create).with(:link => link).and_return(seed)

        response = get :create, :body => {:link => link}
        json_response = JSON.parse(response.body)
        json_response["seed"]["link"].should eq(link)
      end
    end
  end

  pending "seed with a donation"

  context "seed exists" do
    pending "foo"
  end
end

end
