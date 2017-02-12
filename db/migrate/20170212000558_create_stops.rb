class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops do |t|
      t.references :parent_station
      t.string     :external_id
      t.string     :code
      t.string     :name
      t.string     :description
      t.float      :lattitude
      t.float      :longitute
      t.string     :url
      t.integer    :location_type, default: 0
      t.integer    :wheelchair_boarding, default: 0

      t.timestamps
    end
    add_foreign_key :stops, :stops, column: :parent_station_id
  end
end
