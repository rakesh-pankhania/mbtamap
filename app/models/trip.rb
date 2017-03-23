class Trip < ApplicationRecord
  belongs_to :route
  belongs_to :service, polymorphic: true
  belongs_to :shape, optional: true
  has_many :stop_times

  validates_uniqueness_of :external_id

  DIRECTIONS = %w(outbound inbound)

  def direction
    DIRECTIONS[direction_id].titleize
  end
end
