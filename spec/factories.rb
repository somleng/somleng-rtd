FactoryGirl.define do
  factory :project do
    name "Somleng Demo"
    description "Demo of the Somleng Project"
    homepage "https://demo.somleng.org"

    twilreapi_host "https://app.somleng.org/api"
    twilreapi_account_sid "ACC1234567890"
    twilreapi_auth_token "AT1234567890"
    country_code "KH"
    phone_calls_count 0
    sms_count 0
    amount_saved(Money.new(0, Project::DEFAULT_CURRENCY))
  end
end
