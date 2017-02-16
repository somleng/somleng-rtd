class Api::RealTimeDataController < Api::BaseController
  private

  def find_resource
    @resource = RealTimeData.new
    @resource.query_filter = query_filter
    @resource.project = Project.find(params[:project_id]) if params[:project_id]
    @resource
  end
end
