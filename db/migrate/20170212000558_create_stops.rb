class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops do |t|
      t.string  :external_id, null: false, unique: true, index: true
      t.string  :parent_station_external_id, index: true
      t.string  :code
      t.string  :name, null: false
      t.string  :description
      t.float   :lattitude, null: false
      t.float   :longitude, null: false
      t.string  :url
      t.integer :location_type, default: 0
      t.integer :wheelchair_boarding, default: 0

      t.timestamps
    end
  end
end
