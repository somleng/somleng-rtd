class Api::RealTimeDataController < Api::BaseController
  private

  def find_resource
    @resource = RealTimeData.new
  end
end
