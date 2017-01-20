class RealTimeDataController < ApplicationController
  def show
    @real_time_data = RealTimeData.new
    @projects = Project.all
  end
end
