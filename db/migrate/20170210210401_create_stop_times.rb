class CreateStopTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :stop_times do |t|
      t.references :trip, null: false
      t.references :stop, null: false
      t.integer    :arrival_minutes_past_midnight, null: false
      t.integer    :departure_minutes_past_midnight, null: false
      t.integer    :stop_sequence, null: false
      t.string     :stop_headsign
      t.integer    :pickup_type
      t.integer    :drop_off_type

      t.timestamps
    end
  end
end
