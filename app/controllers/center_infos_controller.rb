class CenterInfosController < ApplicationController
  layout false
  caches_page :show

  def show
    @group = Center.find(params[:id])
  end
end