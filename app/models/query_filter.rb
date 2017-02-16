class QueryFilter
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :start_date, :end_date

  validates :start_date, :date => {:allow_nil => true}
  validates :end_date,   :date => {:on_or_after => :start_date, :allow_nil => true}

  before_validation :parse_dates

  def initialize(params = {})
    self.start_date = params["StartDate"]
    self.end_date = params["EndDate"]
  end

  private

  def parse_dates
    parsed_start_date = parse_date(start_date)
    parsed_end_date = parse_date(end_date)
    self.start_date = parsed_start_date if parsed_start_date
    self.end_date = parsed_end_date if parsed_end_date
  end

  def parse_date(date_string)
    Date.parse(date_string.to_s) rescue nil
  end
end
