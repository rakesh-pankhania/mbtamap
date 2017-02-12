class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string   :external_id, null: false
      t.boolean  :monday, null: false
      t.boolean  :tuesday, null: false
      t.boolean  :wednesday, null: false
      t.boolean  :thursday, null: false
      t.boolean  :friday, null: false
      t.boolean  :saturday, null: false
      t.boolean  :sunday, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false

      t.timestamps
    end
  end
end
