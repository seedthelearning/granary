class Api::V1::SeedsController < ApplicationController
  respond_to :json

  def create
    seed = Seed.create(:link => params[:body][:link])
    render :json => seed, :status => :created
  end
end
