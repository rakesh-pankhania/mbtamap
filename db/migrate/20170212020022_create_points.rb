class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.references :shape, null: false
      t.float      :lattitude, null: false
      t.float      :longitude, null: false
      t.integer    :sequence, null: false
      t.float      :dist_traveled

      t.timestamps
    end
  end
end
