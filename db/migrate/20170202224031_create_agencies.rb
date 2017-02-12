class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :external_id
      t.string :name, null: false
      t.string :url, null: false
      t.string :timezone, null: false
      t.string :language
      t.string :phone

      t.timestamps
    end
  end
end
