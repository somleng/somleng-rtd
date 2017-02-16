class ProjectAggregation < ApplicationRecord
  extend DateFilter::Scopes

  DEFAULT_CURRENCY = "USD"

  belongs_to :project, :touch => true

  validates :project, :presence => true
  validates :project_id, :uniqueness => { :scope => [:year, :month, :day] }

  validates :phone_calls_count, :sms_count,
            :presence => true,
            :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :amount_saved, :presence => true, :numericality => true

  monetize :amount_saved_cents,
           :with_currency => DEFAULT_CURRENCY

  validates :year, :month, :day, :presence => true

  delegate :twilreapi_account_sid,
           :twilreapi_auth_token,
           :twilreapi_host,
           :twilio_price,
           :to => :project

  def self.by_date(date)
    where(:year => date.year, :month => date.month, :day => date.day)
  end

  def self.amount_saved
    Money.new(sum(:amount_saved_cents), DEFAULT_CURRENCY)
  end

  def as_json(options = nil)
    options ||= {}
    super(options).merge("amount_saved" => amount_saved.format)
  end

  def fetch!
    usage = {
      :outbound_call_minutes => 0,
      :outbound_call_price => Money.new(0, DEFAULT_CURRENCY),
      :outbound_sms_count => 0,
      :outbound_sms_price => Money.new(0, DEFAULT_CURRENCY)
    }

    date = Date.new(year, month, day).to_s

    twilio_client.account.usage.records.list(:start_date => date, :end_date => date).each do |record|
      case record.category
      when "calls"
        self.phone_calls_count = record.count
      when "calls-outbound"
        usage[:outbound_call_minutes] = record.count.to_i
        usage[:outbound_call_price] = price_to_money(record.price, record.price_unit)
      when "sms"
        self.sms_count = record.count
      when "sms-outbound"
        usage[:outbound_sms_count] = record.count.to_i
        usage[:outbound_sms_price] = price_to_money(record.price, record.price_unit)
      end
    end

    self.amount_saved = calculate_amount_saved(
      total_price(usage),
      calculate_twilio_price(usage)
    )

    save!
  end

  private

  def price_to_money(price_string, currency_string)
    currency = Money::Currency.find(currency_string)
    Money.new(price_string.to_f * currency.subunit_to_unit, currency)
  end

  def calculate_amount_saved(total_price, equivalent_twilio_price)
    equivalent_twilio_price - total_price
  end

  def total_price(usage)
    usage[:outbound_call_price] + usage[:outbound_sms_price]
  end

  def calculate_twilio_price(usage)
    twilio_outbound_voice_price = twilio_price.calculate_outbound_voice_price(
      usage[:outbound_call_minutes]
    )
    twilio_outbound_sms_price = twilio_price.calculate_outbound_sms_price(
      usage[:outbound_sms_count]
    )
    twilio_outbound_voice_price + twilio_outbound_sms_price
  end

  def twilio_client
    @twilio_client ||= Twilreapi::Client.new(
      twilreapi_account_sid,
      twilreapi_auth_token,
      :host => twilreapi_host
    )
  end
end
