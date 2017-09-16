class Stop < ApplicationRecord
  has_many :stop_times, foreign_key: 'stop_external_id', primary_key: 'external_id'
  has_many :child_stops, class_name: 'Stop', foreign_key: 'parent_station_external_id', primary_key: 'external_id'
  belongs_to :parent_station, class_name: 'Stop', foreign_key: 'parent_station_external_id', primary_key: 'external_id'
end
