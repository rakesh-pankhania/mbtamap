class Trip < ApplicationRecord
  belongs_to :route
  belongs_to :service
  belongs_to :shape
  has_many :stop_times
end
