class RemoveAggregationColumnsFromPhoneCalls < ActiveRecord::Migration[5.0]
  def change
    remove_column(:projects, :phone_calls_count, :integer, :null => false)
    remove_column(:projects, :sms_count, :integer, :null => false)
    remove_column(:projects, :amount_saved_cents, :integer, :null => false)
  end
end
