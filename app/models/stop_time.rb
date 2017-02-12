class StopTime < ApplicationRecord
	belongs_to :stop
	belongs_to :trip

  def arrival_time
  end

  def departure_time
  end
end
