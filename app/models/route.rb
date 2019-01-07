# frozen_string_literal: true

class Route < ApplicationRecord
  extend FriendlyId

  belongs_to :agency, foreign_key: 'agency_external_id', primary_key: 'external_id'
  has_many :trips, foreign_key: 'route_external_id', primary_key: 'external_id'
  has_many :shapes, through: :trips
  has_many :stops, through: :trips

  validate :name_given
  validate :route_type_within_range

  friendly_id :name, use: %i[slugged finders]

  ROUTE_TYPES = [
    'Light rail',
    'Subway',
    'Rail',
    'Bus',
    'Ferry',
    'Cable car',
    'Gondola',
    'Funicular'
  ].freeze

  def name
    return "#{short_name} (#{long_name})" if short_name.present? && long_name.present?
    return short_name if short_name.present?

    long_name
  end

  def route_type_name
    [route_type]
  end

  private

  def name_given
    errors.add(:base, 'Short or long name must be specified') if long_name.blank? && short_name.blank?
  end

  def route_type_within_range
    errors.add(:route_type, 'Unsupported route type') if route_type.negative? || route_type > ROUTE_TYPES.length
  end
end
