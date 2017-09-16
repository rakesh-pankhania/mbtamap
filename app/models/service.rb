class Service < ApplicationRecord
  has_many :service_addendums, foreign_key: 'service_external_id', primary_key: 'external_id'
  has_one :trip, foreign_key: 'service_external_id', primary_key: 'external_id'

  def valid_today?
  	service_addendums.each do |service_addendum|
      next unless service_addendum.date == Date.today
      return true if service_addendum.exception_type == 1
      return false if service_addendum.exception_type == 2
  	end
    return false unless (start_date <= DateTime.now) && (DateTime.now <= end_date)
    return false unless send("#{Date::DAYNAMES[DateTime.now.wday].downcase}?".to_sym)
    true
  end
end
