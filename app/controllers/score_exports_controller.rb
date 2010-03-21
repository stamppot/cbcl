class ScoreExportsController < ApplicationController
  # RESTful /score_exports/:center_code

  # return sum scores for a given center
  def show
    center = Center.find_by_code(params[:id])

  end






  private

  def check_access
    redirect_to login_path unless current_user
    redirect_to login_path unless current_user.access? :score_exports
  end
  
end