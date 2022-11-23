class Shift < ApplicationRecord
	# associations
	belongs_to :service
	has_many :assignments, dependent: :destroy

	# enums
	enum day: %w[monday tuesday wednesday thursday friday saturday sunday]


	# validations
	
	# regex to validate if time has "HH:MM" format
	validates :start_time, 
		presence: true, 
		format: { with: %r{([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z}i }, 
		comparison: { less_than: :end_time }

	validates :end_time, 
		presence: true, 
		format: { with: %r{([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z}i }

	validates :day,
		presence: true, inclusion: { in: Shift.days }

	validate :is_valid_day_and_service


	private
	# validates if the day does not have a shift for a specific service
	def is_valid_day_and_service
		# validate if service_id exists
		return errors.add("Invalid service id provided") unless Service.find(self.service_id).present?

		# get the shift for the service and day provided
		invalid_day = Shift.where(id: self.service_id, day: self.day).count == 1
		errors.add(:day, "Service with id #{self.service_id} has already a shift on #{self.day}") if invalid_day
	end
end
