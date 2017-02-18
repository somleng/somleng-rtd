class RemoveAggregationColumnsFromPhoneCalls < ActiveRecord::Migration[5.0]
  def change
    remove_column(:projects, :phone_calls_count, :integer)
    remove_column(:projects, :sms_count, :integer)
    remove_column(:projects, :amount_saved_cents, :integer)
  end
end
