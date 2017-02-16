class CreateProjectAggregations < ActiveRecord::Migration[5.0]
  def change
    create_table(:project_aggregations, :id => :uuid, :default => "gen_random_uuid()") do |t|
      t.references(:project, :type => :uuid, :index => true, :foreign_key => true, :null => false)
      t.integer(:year, :null => false)
      t.integer(:month, :null => false)
      t.integer(:day, :null => false)
      t.integer(:sms_count, :null => false)
      t.integer :phone_calls_count, :null => false
      t.integer :sms_count, :null => false
      t.monetize(
        :amount_saved,
        :amount =>   {:default => nil},
        :currency => {:present => false}
      )
      t.timestamps
    end

    add_index(:project_aggregations, [:year, :month, :day, :project_id], :unique => true, :name => "index_project_aggregations_on_date_and_project_id")
  end
end
