class Stop < ApplicationRecord
  has_many :stop_times
  has_many :child_stops, class_name: "Stop", foreign_key: "parent_station_id"
  belongs_to :parent_station, class_name: "Stop"

  validates_uniqueness_of :external_id
end
