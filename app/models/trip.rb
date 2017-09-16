class Trip < ApplicationRecord
  belongs_to :route, foreign_key: 'route_external_id', primary_key: 'external_id'
  belongs_to :service, foreign_key: 'service_external_id', primary_key: 'external_id'
  belongs_to :shape, optional: true, foreign_key: 'shape_external_id', primary_key: 'external_id'
  has_many :stop_times, foreign_key: 'trip_external_id', primary_key: 'external_id'

  DIRECTIONS = %w(outbound inbound)

  def direction
    DIRECTIONS[direction_id].titleize
  end
end
