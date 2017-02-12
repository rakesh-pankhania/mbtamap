class Trip < ApplicationRecord
  belongs_to :route
  belongs_to :service, polymorphic: true
  belongs_to :shape, optional: true
  has_many :stop_times

  validates_uniqueness_of :external_id

  def direction
    %w(Outbound Inbound)[direction_id]
  end
end
