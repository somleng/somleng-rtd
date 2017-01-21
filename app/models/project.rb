class Project < ApplicationRecord
  include ApiResource
  include TwilioTimestamps

  DEFAULT_CURRENCY = "USD"
  HOSTNAME_REGEXP = /\A(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\z/

  belongs_to :twilio_price

  validates :name, :description, :twilio_price, :presence => true

  validates :homepage, :presence => true, :url => {:no_local => true}
  validates :twilreapi_host, :presence => true, :format => HOSTNAME_REGEXP
  validates :twilreapi_account_sid, :twilreapi_auth_token, :presence => true

  validates :phone_calls_count, :sms_count,
            :presence => true,
            :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :amount_saved, :presence => true, :numericality => true

  validates :status, :presence => true

  store :encryption_data,
        :accessors => [
          :encrypted_twilreapi_account_sid_iv,
          :encrypted_twilreapi_auth_token_iv
        ]

  attr_encrypted :twilreapi_account_sid,
                 :key => Rails.application.secrets[:twilreapi_account_sid_encryption_key]

  attr_encrypted :twilreapi_auth_token,
                 :key => Rails.application.secrets[:twilreapi_auth_token_encryption_key]

  monetize :amount_saved_cents,
           :with_currency => DEFAULT_CURRENCY

  delegate :country_name, :to => :twilio_price
  delegate :voice_url, :sms_url, :to => :twilio_price, :prefix => true

  include AASM

  aasm :column => :status do
    state :published, :initial => true
  end

  def self.amount_saved
    Money.new(sum(:amount_saved_cents), DEFAULT_CURRENCY)
  end

  def self.fetch!
    all.include(:twilio_price).find_each { |project| project.fetch! }
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

    twilio_client.account.usage.records.list.each do |record|
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

  def json_attributes
    super.merge(
      :id => nil,
      :name => nil,
      :description => nil,
      :homepage => nil,
      :phone_calls_count => nil,
      :sms_count => nil,
    )
  end

  def json_methods
    super.merge(
      :date_created => nil,
      :twilio_price => nil,
      :amount_saved => nil,
    )
  end
end
