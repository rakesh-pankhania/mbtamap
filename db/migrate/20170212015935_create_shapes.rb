class CreateShapes < ActiveRecord::Migration[5.0]
  def change
    create_table :shapes do |t|
      t.string :external_id, null: false, unique: true, index: true

      t.timestamps
    end
  end
end
