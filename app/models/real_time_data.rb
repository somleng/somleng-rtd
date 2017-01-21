class RealTimeData
  include ActiveModel::Serializers::JSON
  include ApiResource

  def attributes
    {}
  end

  def updated_at
    project = Project.order(:updated_at => :desc).first
    project && project.updated_at
  end

  def date_updated
    updated_at && updated_at.rfc2822
  end

  def projects_count
    Project.count
  end

  def phone_calls_count
    Project.sum(:phone_calls_count)
  end

  def sms_count
    Project.sum(:sms_count)
  end

  def amount_saved
    Project.amount_saved.format
  end

  private

  def json_methods
    super.merge(
      :phone_calls_count => nil,
      :sms_count => nil,
      :projects_count => nil,
      :amount_saved => nil
    )
  end
end
