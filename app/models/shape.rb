class Shape < ApplicationRecord
  has_many :points
  has_many :trips

  validates_uniqueness_of :external_id
end
