class Api::V1::ParticipantsController < ApplicationController

	def create
    link = params[:link]
    origin = Seed.find(:link => link)
    user_id = params[:user_id]

    if origin && !origin.helper?(user_id)
      @participant = Participant.create_with_origin(origin, user_id)
      render "create", :status => :created
    else
      render :json => {"error" => "No seed provided"}, :status => :bad_request
    end 
  end
end
