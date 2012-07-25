class Api::V1::TreesController < ApplicationController

  # Utilizes jRuby find method to show Seed by ID
  def show
    @seed = Seed.find(:link => params["id"])
    if @seed
      render :json => @seed.tree, :status => :ok
    else
      render :json => {error: "The specified seed does not exist."}, :status => :not_found
    end
  end  
end
