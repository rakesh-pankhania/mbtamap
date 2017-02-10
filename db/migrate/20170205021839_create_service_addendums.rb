class CreateServiceAddendums < ActiveRecord::Migration[5.0]
  def change
    create_table :service_addendums do |t|
      t.references :service
      t.datetime   :date
      t.integer    :exception_type

      t.timestamps
    end
  end
end
