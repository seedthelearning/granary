require 'spec_helper'

describe "/api/v1/trees", :type => :api do
	describe "#show" do
    context "given a seed" do
      it "returns seeds"
      it "returns reseeds"
    end

    context "given a bad seed" do
      it "returns a 404 not found"
    end
  end
end

# Find the root seed via the link
# Get all helpers of root seed
# Get all reseeds of root seed

# { id: 1, link: foo.com, type: seed,
#           children: [ { id: 2, link: foo, type: seed }, { id: 2, link: foo, type: seed }, { id: 3, type: participant } ]
# }
