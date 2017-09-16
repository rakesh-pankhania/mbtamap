class Agency < ApplicationRecord
  has_many :routes, foreign_key: 'agency_external_id', primary_key: 'external_id'
end
