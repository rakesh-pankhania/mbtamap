class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.string  :from_stop_external_id, null: false, index: true
      t.string  :to_stop_external_id, null: false, index: true
      t.integer :transfer_type, null: false
      t.integer :min_transfer_time

      t.timestamps
    end
  end
end
