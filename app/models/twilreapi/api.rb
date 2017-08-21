class Twilreapi::Api < Twilio::REST::Api
  def initialize(twilio)
    super

    @host = twilio.twilreapi_host
    @base_url = "https://#{twilio.twilreapi_host}/api"
  end
end
