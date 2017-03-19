class StopTime < ApplicationRecord
	belongs_to :stop
	belongs_to :trip

  def arrival_time
    (DateTime.now.at_midnight + arrival_minutes_past_midnight.minutes).strftime("%l:%M %P")
  end

  def departure_time
    (DateTime.now.at_midnight + departure_minutes_past_midnight.minutes).strftime("%l:%M %P")
  end
end
