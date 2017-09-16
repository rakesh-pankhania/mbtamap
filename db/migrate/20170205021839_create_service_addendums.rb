class CreateServiceAddendums < ActiveRecord::Migration[5.0]
  def change
    create_table :service_addendums do |t|
      t.string   :service_external_id, null: false, index: true
      t.datetime :date, null: false
      t.integer  :exception_type, null: false

      t.timestamps
    end
  end
end
