class HomesController < ApplicationController
  def show
    @real_time_data = RealTimeData.new
    @projects = Project.all
    @sample_project = Project.first
  end
end
