class Twilreapi::Client < Twilio::REST::Client
  attr_accessor :twilreapi_host

  def api
    @api ||= Twilreapi::Api.new(self)
  end
end
