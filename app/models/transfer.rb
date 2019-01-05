# frozen_string_literal: true

class Transfer < ApplicationRecord
  belongs_to :from_stop, class_name: 'Stop', foreign_key: 'from_stop_external_id', primary_key: 'external_id'
  belongs_to :to_stop, class_name: 'Stop', foreign_key: 'to_stop_external_id', primary_key: 'external_id'
end
