class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.string  :route_external_id, null: false, index: true
      t.string  :service_external_id, null: false, index: true
      t.string  :shape_external_id
      t.string  :external_id, null: false, unique: true, index: true
      t.string  :headsign
      t.string  :short_name
      t.integer :direction_id
      t.string  :block_id
      t.integer :wheelchair_accessible
      t.integer :bikes_allowed

      t.timestamps
    end
  end
end
