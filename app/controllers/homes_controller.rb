class HomesController < ApplicationController
  def show
    @real_time_data = RealTimeData.new
    @projects = projects_scope.order(:created_at).includes(:twilio_price)
    @sample_project = @projects.first
  end
end
