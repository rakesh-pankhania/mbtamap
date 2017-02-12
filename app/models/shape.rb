class Shape < ApplicationRecord
  has_many :points
  has_many :trips
end
