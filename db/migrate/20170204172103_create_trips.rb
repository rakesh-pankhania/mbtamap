class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.references :route
      t.references :service, polymorphic: true, index: true
      # t.references :shape
      t.string     :external_id
      t.string     :headsign
      t.string     :short_name
      t.integer    :direction
      t.string     :block_id
      t.integer    :wheelchair_accessible
      t.integer    :bikes_allowed

      t.timestamps
    end
  end
end
