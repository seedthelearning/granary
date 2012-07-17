class Api::V1::ParticipantsController < ApplicationController

	def create
    link = params["body"]["link"]
    origin = Seed.find(:link => link)
    
    if origin
      @participant = Participant.create_with_origin(origin)
      render "create", :status => :created
    else
      render :json => {"error" => "No seed provided"}, :status => :bad_request
    end 
  end

end
