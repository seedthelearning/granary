class Api::V1::TreesController < ApplicationController

  def show
    @seed = Seed.find(:id => params["id"])
    if @seed
      render :json => @seed.tree, :status => :ok
    else
      render :json => {error: "The specified seed does not exist."}, :status => :not_found
    end
  end  
end
