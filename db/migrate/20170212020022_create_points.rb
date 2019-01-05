# frozen_string_literal: true

class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.string  :shape_external_id, null: false, index: true
      t.float   :lattitude, null: false
      t.float   :longitude, null: false
      t.integer :sequence, null: false
      t.float   :dist_traveled

      t.timestamps
    end
  end
end
