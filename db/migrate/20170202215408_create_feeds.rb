# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.string   :publisher_name
      t.string   :publisher_url
      t.string   :lang
      t.datetime :start_date
      t.datetime :end_date
      t.string   :version

      t.timestamps
    end
  end
end
