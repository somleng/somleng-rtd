class AddNotNullConstraintToTwilioInboundPrices < ActiveRecord::Migration[5.0]
  def up
    change_column(:twilio_prices, :average_inbound_voice_price_microunits, :integer, :null => false)
    change_column(:twilio_prices, :average_inbound_sms_price_microunits, :integer, :null => false)
  end

  def down
    change_column(:twilio_prices, :average_inbound_voice_price_microunits, :integer, :null => true)
    change_column(:twilio_prices, :average_inbound_sms_price_microunits, :integer, :null => true)
  end
end
