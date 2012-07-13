class Api::V1::SeedsController < ApplicationController

  def index
    render :text => "hi"
  end

  def create
    seed = Seed.create(:link => params[:body][:link])
    render :json => seed, :status => :created
  end

  def show
    @seed = Seed.find(params[:id])
    # raise seed.inspect
    # render :json => seed, :status => :ok
  end
end
