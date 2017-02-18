class ProjectAggregation < ApplicationRecord
  extend DateFilter::Scopes

  DEFAULT_CURRENCY = "USD"

  belongs_to :project, :touch => true

  validates :project, :presence => true
  validates :date, :presence => true, :uniqueness => { :scope => [:project_id] }

  [:calls, :calls_inbound, :calls_outbound, :sms, :sms_inbound, :sms_outbound].each do |aggregation|
    validates "#{aggregation}_count",
              :presence => true,
              :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

    validates "#{aggregation}_price",
              :presence => true, :numericality => true

    monetize "#{aggregation}_price_cents", :with_currency => DEFAULT_CURRENCY
  end

  validates :calls_minutes, :calls_inbound_minutes, :calls_outbound_minutes,
            :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  delegate :twilreapi_account_sid,
           :twilreapi_auth_token,
           :twilreapi_host,
           :twilio_price,
           :to => :project

  def self.calls_count
    sum(:calls_count)
  end

  def self.calls_inbound_count
    sum(:calls_inbound_count)
  end

  def self.calls_outbound_count
    sum(:calls_outbound_count)
  end

  def self.calls_minutes
    sum(:calls_minutes)
  end

  def self.calls_inbound_minutes
    sum(:calls_inbound_minutes)
  end

  def self.calls_outbound_minutes
    sum(:calls_outbound_minutes)
  end

  def self.sms_count
    sum(:sms_count)
  end

  def self.sms_inbound_count
    sum(:sms_inbound_count)
  end

  def self.sms_outbound_count
    sum(:sms_outbound_count)
  end

  def self.by_date(date)
    where(:date => date)
  end

  def self.total_equivalent_twilio_price
    TwilioPrice.exchange_to_usd(
      joins(:project => :twilio_price).sum(total_equivalent_twilio_price_sum_sql)
    )
  end

  def self.total_amount_spent
    Money.new(sum(total_amount_spent_sum_sql), DEFAULT_CURRENCY)
  end

  def self.total_amount_saved
    total_equivalent_twilio_price - total_amount_spent
  end

  def as_json(options = nil)
    options ||= {}
    super(options).merge("amount_saved" => amount_saved.format)
  end

  def fetch!
    twilio_client.account.usage.records.list(:start_date => date, :end_date => date).each do |record|
      case record.category
      when "calls"
        self.calls_count = record.count
        self.calls_minutes = record.usage
        self.calls_price = price_to_money(record.price, record.price_unit)
      when "calls-inbound"
        self.calls_inbound_count = record.count
        self.calls_inbound_minutes = record.usage
        self.calls_inbound_price = price_to_money(record.price, record.price_unit)
      when "calls-outbound"
        self.calls_outbound_count = record.count
        self.calls_outbound_minutes = record.usage
        self.calls_outbound_price = price_to_money(record.price, record.price_unit)
      when "sms"
        self.sms_count = record.count
        self.sms_price = price_to_money(record.price, record.price_unit)
      when "sms-inbound"
        self.sms_inbound_count = record.count
        self.sms_inbound_price = price_to_money(record.price, record.price_unit)
      when "sms-outbound"
        self.sms_outbound_count = record.count
        self.sms_outbound_price = price_to_money(record.price, record.price_unit)
      end
    end

    save!
  end

  private

  def self.between_dates_column_name
    :date
  end

  def self.total_equivalent_twilio_price_sum_sql
    [[:calls_inbound_minutes, :inbound_voice], [:calls_outbound_minutes, :outbound_voice], [:sms_inbound_count, :inbound_sms], [:sms_outbound_count, :outbound_sms]].map { |table_columns| "(\"#{TwilioPrice.table_name}\".\"average_#{table_columns[1]}_price_microunits\" * \"#{table_name}\".\"#{table_columns[0]}\")" }.join(" + ")
  end

  def self.total_amount_spent_sum_sql
    [:calls_inbound, :calls_outbound, :sms_inbound, :sms_outbound].map { |table_column| "\"#{table_name}\".\"#{table_column}_price_cents\"" }.join(" + ")
  end

  def price_to_money(price_string, currency_string)
    currency = Money::Currency.find(currency_string)
    Money.new(price_string.to_f * currency.subunit_to_unit, currency)
  end

  def twilio_client
    @twilio_client ||= Twilreapi::Client.new(
      twilreapi_account_sid,
      twilreapi_auth_token,
      :host => twilreapi_host
    )
  end
end
