class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    enable_extension "uuid-ossp"

    create_table :feeds do |t|
      t.string   :version
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
