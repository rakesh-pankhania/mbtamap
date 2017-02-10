class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string   :external_id
      t.boolean  :monday
      t.boolean  :tuesday
      t.boolean  :wednesday
      t.boolean  :thursday
      t.boolean  :friday
      t.boolean  :saturday
      t.boolean  :sunday
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
