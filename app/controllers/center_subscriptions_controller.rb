class CenterSubscriptionsController < ApplicationController

  def show
    @group = Center.find(params[:id], :include => :teams)
    @subscription_presenter = @group.subscription_presenter
    @subscriptions = @group.subscriptions

    puts "SUBSCRIPTIONS: #{@subscriptions.count}"
    render :partial => 'centers/subscriptions'
    # respond_to do |format|
    #   format.html { render :partial => 'centers/subscriptions' }
    #   format.js { render :partial => 'centers/subscriptions' }
    # end
  end
end