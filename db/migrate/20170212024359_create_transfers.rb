class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.references :from_stop, null: false
      t.references :to_stop, null: false
      t.integer    :transfer_type, null: false
      t.integer    :min_transfer_time

      t.timestamps
    end
    add_foreign_key :transfers, :stops, column: :from_stop_id
    add_foreign_key :transfers, :stops, column: :to_stop_id
  end
end
