# frozen_string_literal: true

class ServiceAddendum < ApplicationRecord
  belongs_to :service, foreign_key: 'service_external_id', primary_key: 'external_id'
end
