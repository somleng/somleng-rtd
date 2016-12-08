class RemoveAmountSavedCurrencyFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column(:projects, :amount_saved_currency, :string)
  end
end
