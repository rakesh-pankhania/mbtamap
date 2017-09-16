class CreateStopTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :stop_times do |t|
      t.string   :trip_external_id, null: false, index: true
      t.string   :stop_external_id, null: false, index: true
      t.string   :arrival_time, null: false
      t.string   :departure_time, null: false
      t.integer  :stop_sequence, null: false
      t.string   :stop_headsign
      t.integer  :pickup_type
      t.integer  :drop_off_type

      t.timestamps
    end
  end
end
