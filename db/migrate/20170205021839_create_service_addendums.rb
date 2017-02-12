class CreateServiceAddendums < ActiveRecord::Migration[5.0]
  def change
    create_table :service_addendums do |t|
      t.references :service, null: false
      t.datetime   :date, null: false
      t.integer    :exception_type, null: false

      t.timestamps
    end
  end
end
