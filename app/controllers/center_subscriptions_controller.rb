class CenterSubscriptionsController < ApplicationController

  def show
    @group = Center.find(params[:id], :include => :teams)
    @subscription_presenter = @group.subscription_presenter
    @subscriptions = @group.subscriptions

    render :partial => 'centers/subscriptions'
  end
end