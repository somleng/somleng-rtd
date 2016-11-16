class Project < ApplicationRecord
  DEFAULT_CURRENCY = "USD"

  validates :name, :description, :presence => true

  validates :homepage, :presence => true, :url => {:no_local => true}
  validates :twilreapi_host, :presence => true, :url => {:no_local => true}

  validates :country_code, :presence => true, :inclusion => {:in => :available_countries}

  validates :phone_calls_count, :sms_count,
            :presence => true,
            :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :phone_call_average_cost_per_minute, :sms_average_cost_per_message,
            :presence => true,
            :numericality => { :greater_than_or_equal_to => 0 }

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

  delegate :available_countries,
           :currency,
           :to => :class

  include AASM

  aasm :column => :status do
    state :published, :initial => true
  end

  def self.available_countries
    ISO3166::Country.codes
  end

  def self.twilio_phone_call_cost_per_minute(country_code)
    ENV["TWILIO_PHONE_CALL_COST_PER_MINUTE_#{country_code}"].to_f
  end

  def self.twilio_sms_cost_per_message(country_code)
    ENV["TWILIO_SMS_COST_PER_MESSAGE_#{country_code}"].to_f
  end

  def self.twilio_pricing_url(type, country_code)
    "https://www.twilio.com/#{type}/pricing/#{country_code.downcase}"
  end

  def self.currency
    DEFAULT_CURRENCY
  end

  def serializable_hash(options = nil)
    options ||= {}
    super(
      {
        :only    => json_attributes.keys,
        :methods => json_methods.keys
      }.merge(options)
    )
  end

  def date_created
    created_at.rfc2822
  end

  def date_updated
    updated_at.rfc2822
  end

  def twilio_phone_call_cost_per_minute
    self.class.twilio_phone_call_cost_per_minute(country_code)
  end

  def twilio_sms_cost_per_message
    self.class.twilio_sms_cost_per_message(country_code)
  end

  def twilio_phone_call_pricing_url
    self.class.twilio_pricing_url(:voice, country_code)
  end

  def twilio_sms_pricing_url
    self.class.twilio_pricing_url(:sms, country_code)
  end

  private

  def json_attributes
    {
      :id => nil,
      :name => nil,
      :description => nil,
      :homepage => nil,
      :country_code => nil,
      :phone_calls_count => nil,
      :sms_count => nil,
      :total_amount_saved => nil,
      :phone_call_average_cost_per_minute => nil,
      :sms_average_cost_per_message => nil,
      :amount_saved => nil,
    }
  end

  def json_methods
    {
      :date_created => nil,
      :date_updated => nil,
      :twilio_phone_call_cost_per_minute => nil,
      :twilio_sms_cost_per_message => nil,
      :twilio_phone_call_pricing_url => nil,
      :twilio_sms_pricing_url => nil,
      :currency => nil
    }
  end
end