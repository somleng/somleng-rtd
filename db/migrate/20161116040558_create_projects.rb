class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    enable_extension('pgcrypto')
    create_table(:projects, :id => :uuid, :default => "gen_random_uuid()") do |t|
      t.integer :phone_calls_count, :null => false
      t.integer :sms_count, :null => false
      t.string  :name, :null => false
      t.text    :description
      t.string  :homepage
      t.string  :twilreapi_host
      t.text    :encrypted_twilreapi_account_sid, :null => false
      t.text    :encrypted_twilreapi_auth_token, :null => false
      t.text    :encryption_data, :null => false
      t.string  :status, :null => false
      t.string  :country_code, :null => false
      t.decimal :phone_call_average_unit_cost_per_minute, :precision => 5, :scale => 4, :null => false
      t.decimal :sms_average_unit_cost_per_message, :precision => 5, :scale => 4, :null => false
      t.timestamps
    end
  end
end
