FactoryGirl.define do
  factory :project do
    name "Somleng Demo"
    description "Demo of the Somleng Project"
    homepage "https://demo.somleng.org"
    twilreapi_host "app.somleng.org"
    twilreapi_account_sid "ACC1234567890"
    twilreapi_auth_token "AT1234567890"

    after(:build) do |project|
      project.twilio_price = TwilioPrice.first || build(:twilio_price)
    end
  end

  factory :project_aggregation do
    project
    date { Date.new(2016, 9, 30) }
    [:calls, :calls_inbound, :calls_outbound, :sms, :sms_inbound, :sms_outbound].each do |aggregation|
      send("#{aggregation}_count", 0)
      send("#{aggregation}_price_cents", 0)
    end

    calls_minutes 0
    calls_inbound_minutes 0
    calls_outbound_minutes 0
  end

  factory :twilio_price do
    country_code "KH"
    average_outbound_voice_price_microunits 100000
    average_outbound_sms_price_microunits 50000
    average_inbound_voice_price_microunits 7000
    average_inbound_sms_price_microunits 7500
  end

  factory :query_filter do
    skip_create
    start_date { Date.new(2015, 9, 30) }
    end_date { Date.new(2015, 10, 31) }
  end
end
