FactoryGirl.define do
  factory :project do
    name "Somleng Demo"
    description "Demo of the Somleng Project"
    homepage "https://demo.somleng.org"
    twilreapi_host "app.somleng.org"
    twilreapi_account_sid "ACC1234567890"
    twilreapi_auth_token "AT1234567890"
    phone_calls_count 0
    sms_count 0
    amount_saved Money.new(0)

    after(:build) do |project|
      project.twilio_price = TwilioPrice.first || build(:twilio_price)
    end
  end

  factory :twilio_price do
    country_code "KH"
    average_outbound_voice_price Money.new(100000)
    average_outbound_sms_price Money.new(50000)
  end
end
