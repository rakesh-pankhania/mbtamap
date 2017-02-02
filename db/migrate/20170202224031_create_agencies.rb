class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :external_id
      t.string :name
      t.string :url
      t.string :timezone
      t.string :language
      t.string :phone

      t.timestamps
    end
  end
end
