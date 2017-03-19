class Service < ApplicationRecord
  has_many :service_addendums
  has_one :trip

  validates_uniqueness_of :external_id

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
