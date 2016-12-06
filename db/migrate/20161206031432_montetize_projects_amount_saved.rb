class MontetizeProjectsAmountSaved < ActiveRecord::Migration[5.0]
  def up
    change_table :projects do |t|
      t.monetize :amount_saved,
                 :amount =>   {:default => nil, :null => true},
                 :currency => {:default => nil, :null => true}
    end

    Project.update_all(
      :amount_saved_currency => Project::DEFAULT_CURRENCY,
      :amount_saved_cents => 0
    )

    change_column(:projects, :amount_saved_cents, :integer, :null => false)
    change_column(:projects, :amount_saved_currency, :string,  :null => false)
    remove_column(:projects, :amount_saved)
  end

  def down
    add_column(:projects, :amount_saved, :integer, :null => false)
    remove_column(:projects, :amount_saved_cents)
    remove_column(:projects, :amount_saved_currency)
  end
end
