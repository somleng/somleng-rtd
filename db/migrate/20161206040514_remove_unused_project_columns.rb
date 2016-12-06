class RemoveUnusedProjectColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column(:projects, :phone_call_average_cost_per_minute, :decimal, :precision => 5, :scale => 4, :null => false)
    remove_column(:projects, :sms_average_cost_per_message, :decimal, :precision => 5, :scale => 4, :null => false)
    change_column(:projects, :twilreapi_host, :string, :null => false)
  end
end
