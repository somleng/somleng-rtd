class Twilreapi::Client < Twilio::REST::Client
  def build_full_path(path, params, method)
    super("/api" + path, params, method)
  end
end
