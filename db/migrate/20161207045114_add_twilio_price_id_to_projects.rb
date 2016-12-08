class AddTwilioPriceIdToProjects < ActiveRecord::Migration[5.0]
  def up
    change_table :projects do |t|
      t.references(:twilio_price, :type => :uuid, :index => true, :foreign_key => true)
    end
    remove_column(:projects, :country_code)
  end

  def down
    remove_column(:projects, :twilio_price_id)
    add_column(:projects, :country_code, :string)
  end
end
