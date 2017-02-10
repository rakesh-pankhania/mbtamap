class Trip < ApplicationRecord
  belongs_to :route
  belongs_to :service
  has_many :stop_times
end
