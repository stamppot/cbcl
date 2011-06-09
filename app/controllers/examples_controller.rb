class ExamplesController < ApplicationController

  def index
    @group = Center.first
  end
  
  def show
    puts request.xhr? && "XXXXXHHHHDDDRRR" || "NOOOOOOOOOOO XHR"
    render :text => "Tralala: #{params[:id]}"
  end
end
