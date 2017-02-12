class CreateShapes < ActiveRecord::Migration[5.0]
  def change
    create_table :shapes do |t|
      t.string :external_id

      t.timestamps
    end
  end
end
