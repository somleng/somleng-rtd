class RealTimeData
  include ActiveModel::Serializers::JSON
  include ApiResource

  attr_accessor :project, :query_filter

  delegate :start_date, :end_date, :to => :query_filter, :allow_nil => true

  def attributes
    {}
  end

  def updated_at
    project ||= projects.order(:updated_at => :desc).first
    project && project.updated_at
  end

  def date_updated
    updated_at && updated_at.rfc2822
  end

  def projects_count
    projects.count
  end

  def phone_calls_count
    project_aggregations_scope.between_dates(start_date, end_date).sum(:phone_calls_count)
  end

  def sms_count
    project_aggregations_scope.between_dates(start_date, end_date).sum(:sms_count)
  end

  def amount_saved
    project_aggregations_scope.between_dates(start_date, end_date).amount_saved.format
  end

  private

  def projects
    projects_scope.between_dates(start_date, end_date)
  end

  def projects_scope
    project ? Project.where(:id => project.id) : Project.all
  end

  def project_aggregations_scope
    project ? project.project_aggregations : ProjectAggregation.all
  end

  def json_methods
    super.merge(
      :phone_calls_count => nil,
      :sms_count => nil,
      :projects_count => nil,
      :amount_saved => nil
    )
  end
end
