class Availability < ApplicationRecord
	include ErrorUtilities

	belongs_to :user
	belongs_to :service

	validates :start_at, presence: true, comparison: { less_than: :end_at, greater_or_equal_than: Date.current }, format: { with: /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}\z/, message: "must be in the format YYYY-MM-DD HH:MM" }
	validates :end_at, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}\z/, message: "must be in the format YYYY-MM-DD HH:MM" }


	def self.create(availability)

		# get the service and user
		service = Service.find(availability[:service_id])
		user = User.find(availability[:user_id])

		# check if the service is active
		return ErrorUtilities::generate_custom_error("service_id", "Service is inactive") unless service.active

		# create new datetime object with user's start_at and end_at
		start_at = DateTime.parse(availability[:start_at])
		end_at = DateTime.parse(availability[:end_at])

		# get day of the week of end_at
		day_of_week_for_availability = start_at.strftime("%A").downcase

		# filter the service days by day_of_week_for_availability
		service_shifts_for_selected_day = service.shifts.where(day: day_of_week_for_availability)

		# verify if the service has a shift on the day of the week for availability
		return ErrorUtilities::generate_custom_error("service_id", "for service with id #{service.id} not exist a shift for date #{start_at.to_date}") if (service_shifts_for_selected_day.count).zero?

		# verify if start_at and end_at are in the same day
		return ErrorUtilities::generate_custom_error("start_at", "start_at #{start_at.to_date} is not the same day as end_at #{end_at.to_date}") unless start_at.day == end_at.day

		# start_at is greater or equal than service.start_at
		return ErrorUtilities::generate_custom_error("start_at", "start_at is not greater or equal than start date of service #{service.start_at.to_date}") unless start_at >= service.start_at

		# end_at is less than or equal than service.end_at
		return ErrorUtilities::generate_custom_error("end_at", "end_at is not less or equal than end date of service #{service.end_at.to_date}") unless end_at <= service.end_at
		
		# # shift time for the day of the week
		shift_start_time = service_shifts_for_selected_day.first[:start_time]
		shift_end_time = service_shifts_for_selected_day.first[:end_time]

		# # user's availability time
		user_start_time = start_at.strftime("%H:%M")
		user_end_time = end_at.strftime("%H:%M")

		# evaluate if user's availability start time is greater or equal than shift start time
		return ErrorUtilities::generate_custom_error("start_at", "user start_at #{user_start_time} is not greater or equal than shift start time  #{shift_start_time}") unless user_start_time >= shift_start_time

		# evaluate if user's availability end time is less than or equal than shift end time
		return ErrorUtilities::generate_custom_error("end_at", "user end_at #{user_end_time} is not less or equal than shift end time #{shift_end_time}") unless user_end_time <= shift_end_time

		availability = Availability.new(availability)
	end
end
