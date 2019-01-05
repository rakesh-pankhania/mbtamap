# frozen_string_literal: true

class Shape < ApplicationRecord
  has_many :points, foreign_key: 'shape_external_id', primary_key: 'external_id'
  has_many :trips, foreign_key: 'shape_external_id', primary_key: 'external_id'
end
