class Api::V1::SeedsController < ApplicationController

  def create
    link = params[:body][:link]
    cents = params[:body][:amount_cents]
    user_id = params[:body][:user_id]
    if link
      @seed = Seed.reseed(user_id, link, cents)
    else
      @seed = Seed.plant(user_id, cents)
    end
    render "create", :status => :created
  end

  def show
    @seed = Seed.find(params[:id])
    unless @seed
      render :json => {"error" => "Seed not found"}, :status => :not_found
    end
  end

  def index
    @seeds = Seed.all
    unless @seeds
      render :json => []
    end
  end
end
