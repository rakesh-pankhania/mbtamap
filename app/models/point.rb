# frozen_string_literal: true

class Point < ApplicationRecord
  belongs_to :shape, foreign_key: 'shape_external_id', primary_key: 'external_id'
end
