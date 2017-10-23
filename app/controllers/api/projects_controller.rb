class Api::ProjectsController < Api::BaseController
  private

  def find_resources
    super.includes(:twilio_price)
  end

  def association_chain
    projects_scope.between_dates(query_filter.start_date, query_filter.end_date)
  end
end
