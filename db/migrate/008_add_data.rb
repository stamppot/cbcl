class AddData < ActiveRecord::Migration
  def self.up
    # 1.upto(5) do |i|
    #   centers = Center.find(:all)  # BPUH
    #   centers.each do |center|
    #     survey = Survey.find(i)
    #     sub = Subscription.new(:survey => survey, :center => center)
    #     sub.activate!
    #   end
    # end
  end

  def self.down
  #   # Empty all tables in list
  #   adapter = ActiveRecord::Base.configurations['development']['adapter']
  # 
  #   tables = ["Subscription", "Copy"]
  #   Subscription.destroy_all
  #   Copy.destroy_all
  end
end
