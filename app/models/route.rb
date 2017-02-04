class Route < ApplicationRecord
  belongs_to :agency
  has_many :trips

  def name
  	return long_name unless long_name == ''
  	return short_name unless short_name == ''
  	external_id
  end
end
