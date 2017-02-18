class AddInboundPricesToTwilioPrice < ActiveRecord::Migration[5.0]
  def up
    change_table :twilio_prices do |t|
      t.monetize(
        :average_inbound_voice_price,
        :amount => {
          :column_name => :average_inbound_voice_price_microunits,
          :default => nil,
          :null => true
        },
        :currency => {:present => false}
      )

      t.monetize(
        :average_inbound_sms_price,
        :amount => {
          :column_name => :average_inbound_sms_price_microunits,
          :default => nil,
          :null => true
        },
        :currency => {:present => false}
      )
    end
  end

  def down
    remove_column(:twilio_prices, :average_inbound_voice_price_microunits)
    remove_column(:twilio_prices, :average_inbound_sms_price_microunits)
  end
end
