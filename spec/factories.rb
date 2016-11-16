FactoryGirl.define do
  factory :project do
    name "Somleng Demo"
    description "Demo of the Somleng Project"
    homepage "https://demo.somleng.org"

    twilreapi_host "https://app.somleng.org/api"
    twilreapi_account_sid "ACC1234567890"
    twilreapi_auth_token "AT1234567890"
    country_code "KH"
    phone_call_average_unit_cost_per_minute "0.05"
    sms_average_unit_cost_per_message "0.02"
    phone_calls_count 0
    sms_count 0
  end
end
