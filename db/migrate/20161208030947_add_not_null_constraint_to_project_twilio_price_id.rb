class AddNotNullConstraintToProjectTwilioPriceId < ActiveRecord::Migration[5.0]
  def up
    change_column(:projects, :twilio_price_id, :uuid, :null => false)
  end

  def down
    change_column(:projects, :twilio_price_id, :uuid, :null => true)
  end
end
