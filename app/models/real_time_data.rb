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

  def countries_count
    twilio_prices.count
  end

  def continents_count
    (twilio_prices.map { |twilio_price| twilio_price.country.continent }).uniq.count
  end

  def calls_count
    filtered_project_aggregations.calls_count
  end

  def calls_inbound_count
    filtered_project_aggregations.calls_inbound_count
  end

  def calls_outbound_count
    filtered_project_aggregations.calls_outbound_count
  end

  def calls_minutes
    filtered_project_aggregations.calls_minutes
  end

  def calls_inbound_minutes
    filtered_project_aggregations.calls_inbound_minutes
  end

  def calls_outbound_minutes
    filtered_project_aggregations.calls_outbound_minutes
  end

  def sms_count
    filtered_project_aggregations.sms_count
  end

  def sms_inbound_count
    filtered_project_aggregations.sms_inbound_count
  end

  def sms_outbound_count
    filtered_project_aggregations.sms_outbound_count
  end

  def total_amount_spent
    filtered_project_aggregations.total_amount_spent.format
  end

  def total_equivalent_twilio_price
    filtered_project_aggregations.total_equivalent_twilio_price.format
  end

  def total_amount_saved
    filtered_project_aggregations.total_amount_saved.format
  end

  private

  def filtered_project_aggregations
    project_aggregations_scope.between_dates(start_date, end_date)
  end

  def projects
    projects_scope.between_dates(start_date, end_date)
  end

  def twilio_prices_scope
    project ? TwilioPrice.where(:id => project.twilio_price_id) : TwilioPrice.all
  end

  def twilio_prices
    twilio_prices_scope
  end

  def projects_scope
    project ? default_projects_scope.where(:id => project.id) : default_projects_scope
  end

  def default_projects_scope
    Project.published
  end

  def project_aggregations_scope
    project ? project.project_aggregations : ProjectAggregation.all
  end

  def json_methods
    super.merge(
      :calls_count => nil,
      :calls_outbound_count => nil,
      :calls_inbound_count => nil,
      :calls_minutes => nil,
      :calls_outbound_minutes => nil,
      :calls_inbound_minutes => nil,
      :sms_count => nil,
      :sms_outbound_count => nil,
      :sms_inbound_count => nil,
      :projects_count => nil,
      :countries_count => nil,
      :continents_count => nil,
      :total_amount_spent => nil,
      :total_equivalent_twilio_price => nil,
      :total_amount_saved => nil
    )
  end
end
