# frozen_string_literal: true

class StopTime < ApplicationRecord
  belongs_to :stop, foreign_key: 'stop_external_id', primary_key: 'external_id'
  belongs_to :trip, foreign_key: 'trip_external_id', primary_key: 'external_id'

  attr_accessor :predicted_arrival_time
end
