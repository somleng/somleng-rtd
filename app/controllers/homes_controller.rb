class HomesController < ApplicationController
  def show
    @real_time_data = RealTimeData.new
    @projects = Project.all.includes(:twilio_price)
    @sample_project = @projects.first
  end
end
