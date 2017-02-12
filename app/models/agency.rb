class Agency < ApplicationRecord
  has_many :routes

  validates_uniqueness_of :external_id
end
