class TwilioPrice < ApplicationRecord
  include ApiResource
  include TwilioTimestamps

  DEFAULT_CURRENCY = "USD6"
  TWILIO_PRICE_TO_CURRENCY_RATIO = 1000000

  has_many :projects

  validates :country_code, :presence => true, :inclusion => {:in => :available_countries}

  monetize :average_outbound_voice_price_microunits,
           :as => :average_outbound_voice_price,
           :with_currency => DEFAULT_CURRENCY,
           :numericality => { :greater_than_or_equal_to => 0 }

  monetize :average_outbound_sms_price_microunits,
           :as => :average_outbound_sms_price,
           :with_currency => DEFAULT_CURRENCY,
           :numericality => { :greater_than_or_equal_to => 0 }

  monetize :average_inbound_voice_price_microunits,
           :as => :average_inbound_voice_price,
           :with_currency => DEFAULT_CURRENCY,
           :numericality => { :greater_than_or_equal_to => 0 }

  monetize :average_inbound_sms_price_microunits,
           :as => :average_inbound_sms_price,
           :with_currency => DEFAULT_CURRENCY,
           :numericality => { :greater_than_or_equal_to => 0 }

  delegate :available_countries,
           :to => :class

  delegate :name, :to => :country, :prefix => true

  def self.available_countries
    ISO3166::Country.codes
  end

  def self.fetch_new!(*countries)
    countries = ENV["TWILIO_PRICE_COUNTRIES"].to_s.split(";") if countries.empty?
    countries.each do |country_code|
      twilio_price = self.where(:country_code => country_code.upcase).first_or_initialize
      twilio_price.fetch!
    end
  end

  def self.fetch!
    find_each { |twilio_price| twilio_price.fetch! }
  end

  def country
    ISO3166::Country[country_code]
  end

  def fetch!
    fetch_voice!
    fetch_messaging!
    self.average_outbound_voice_price = calculate_average_price(
      @voice_pricing.outbound_prefix_prices
    )
    self.average_inbound_voice_price = calculate_average_price(
      @voice_pricing.inbound_call_prices
    )
    self.average_outbound_sms_price = calculate_average_price(
      @sms_pricing.outbound_sms_prices.map { |price_element| price_element["prices"] }.flatten
    )
    self.average_inbound_sms_price = calculate_average_price(
      @sms_pricing.inbound_sms_prices
    )
    save!
  end

  def outbound_voice_price
    average_outbound_voice_price.format
  end

  def outbound_sms_price
    average_outbound_sms_price.format
  end

  def voice_url
    url(:voice)
  end

  def sms_url
    url(:sms)
  end

  def self.exchange_to_usd(amount_in_microunits)
    Money.new(amount_in_microunits, DEFAULT_CURRENCY).exchange_to("USD")
  end

  private

  def url(type)
    "https://www.twilio.com/#{type}/pricing/#{country_code.downcase}"
  end

  def json_attributes
    super.merge(
      :country_code => nil
    )
  end

  def json_methods
    super.merge(
      :date_created => nil,
      :outbound_voice_price => nil,
      :outbound_sms_price => nil,
      :voice_url => nil,
      :sms_url => nil
    )
  end

  def calculate_average_price(twilio_pricing_data)
    Money.new(
      twilio_pricing_data.inject(0.0) { |sum, price_element|
        sum + price_element["base_price"].to_f * TWILIO_PRICE_TO_CURRENCY_RATIO
      } / (twilio_pricing_data.size.nonzero? || 1),
      DEFAULT_CURRENCY
    )
  end

  def fetch_voice!
    @voice_pricing = twilio_client.pricing.voice.countries(country_code).fetch
  end

  def fetch_messaging!
    @sms_pricing = twilio_client.pricing.messaging.countries(country_code).fetch
  end

  def twilio_client
    @twilio_client ||= Twilio::REST::Client.new(
      ENV["TWILIO_ACCOUNT_SID"],
      ENV["TWILIO_AUTH_TOKEN"]
    )
  end
end
