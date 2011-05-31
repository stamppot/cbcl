class CenterInfosController < ApplicationController

  caches_page :show
  
  def show
    @group = Center.find(params[:id])
  end
end