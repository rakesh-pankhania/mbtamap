# frozen_string_literal: true

class Service < ApplicationRecord
  has_many :service_addendums, foreign_key: 'service_external_id', primary_key: 'external_id'
  has_one :trip, foreign_key: 'service_external_id', primary_key: 'external_id'
end
