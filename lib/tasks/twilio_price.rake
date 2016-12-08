namespace :twilio_price do
  desc "Fetches pricing info for the countries specified in TWILIO_PRICE_COUNTRIES"
  task :fetch_new => :environment do
    TwilioPrice.fetch_new!
  end

  desc "Updates the pricing info for the existing countries"
  task :fetch => :environment do
    TwilioPrice.fetch!
  end
end
