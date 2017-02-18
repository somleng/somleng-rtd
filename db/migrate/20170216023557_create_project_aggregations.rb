class CreateProjectAggregations < ActiveRecord::Migration[5.0]
  def change
    create_table(:project_aggregations, :id => :uuid, :default => "gen_random_uuid()") do |t|
      t.references(:project, :type => :uuid, :index => true, :foreign_key => true, :null => false)
      t.date(:date, :null => false)

      [:calls, :calls_inbound, :calls_outbound, :sms, :sms_inbound, :sms_outbound].each do |aggregation|
        t.integer(:"#{aggregation}_count", :null => false)

        t.monetize(
          "#{aggregation}_price",
          :amount =>   {:default => nil},
          :currency => {:present => false}
        )
      end

      t.integer(:calls_minutes, :null => false)
      t.integer(:calls_inbound_minutes, :null => false)
      t.integer(:calls_outbound_minutes, :null => false)

      t.timestamps
    end

    add_index(:project_aggregations, [:date, :project_id], :unique => true)
  end
end
