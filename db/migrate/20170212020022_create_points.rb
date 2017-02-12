class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.references :shape
      t.float      :lattitude
      t.float      :longitude
      t.integer    :sequence
      t.float      :dist_traveled

      t.timestamps
    end
  end
end
