class NullableStopLatLon < ActiveRecord::Migration[5.1]
  def change
    change_column_null :stops, :lattitude, true
    change_column_null :stops, :longitude, true
  end
end
