class CreateTwilioPrices < ActiveRecord::Migration[5.0]
  def change
    create_table(:twilio_prices, :id => :uuid, :default => "gen_random_uuid()") do |t|
      t.monetize(
        :average_outbound_voice_price,
        :amount => {
          :column_name => :average_outbound_voice_price_microunits,
          :default => nil
        },
        :currency => {:present => false}
      )

      t.monetize(
        :average_outbound_sms_price,
        :amount => {
          :column_name => :average_outbound_sms_price_microunits,
          :default => nil
        },
        :currency => {:present => false}
      )

      t.string(:country_code, :null => false)
      t.timestamps
    end

    add_index(:twilio_prices, :country_code, :unique => true)
  end
end
