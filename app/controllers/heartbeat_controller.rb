class HeartbeatController < ApplicationController

  def index
    c = Center.first
    render :text => "Ok"
    
    rescue RecordNotFound
      render :text => "Bad", :status => 500
    
  end
end