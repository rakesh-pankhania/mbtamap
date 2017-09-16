class Route < ApplicationRecord
  extend FriendlyId

  belongs_to :agency, foreign_key: 'agency_external_id', primary_key: 'external_id'
  has_many :trips, foreign_key: 'route_external_id', primary_key: 'external_id'

  validate :name_given
  validate :route_type_within_range

  friendly_id :name, use: [:slugged, :finders]

  ROUTE_TYPES = [
    "Light rail",
    "Subway",
    "Rail",
    "Bus",
    "Ferry",
    "Cable car",
    "Gondola",
    "Funicular"
  ]

  def name
    return long_name.blank? ? short_name : long_name
  end

  def route_type_name
    [route_type]
  end

  private

  def name_given
    if long_name.blank? && short_name.blank?
      errors.add(:base, "Short or long name must be specified")
    end
  end

  def route_type_within_range
    if route_type < 0 || route_type > ROUTE_TYPES.length
      errors.add(:route_type, "Unsupported route type")
    end
  end
end
