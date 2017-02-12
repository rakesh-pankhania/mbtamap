class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.references :agency
      t.string     :external_id, null: false
      t.string     :short_name
      t.string     :long_name
      t.string     :description
      t.integer    :route_type, null: false
      t.string     :url
      t.string     :color
      t.string     :text_color

      t.timestamps
    end
  end
end
