class Api::V1::SeedsController < ApplicationController

  def create
    @seed = Seed.create(:link => params[:body][:link])
    render "create", :status => :created
  end

  def show
    @seed = Seed.find(params[:id])
    unless @seed
      render :json => {"error" => "Seed not found"}, :status => :not_found
    end
  end
end
