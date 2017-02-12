class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.references :route, null: false
      t.references :service, polymorphic: true, index: true, null: false
      t.references :shape
      t.string     :external_id, null: false
      t.string     :headsign
      t.string     :short_name
      t.integer    :direction_id
      t.string     :block_id
      t.integer    :wheelchair_accessible
      t.integer    :bikes_allowed

      t.timestamps
    end
  end
end
