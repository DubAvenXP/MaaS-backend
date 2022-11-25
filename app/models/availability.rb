class Availability < ApplicationRecord
	include ErrorUtilities

	after_create :execute_assignments

	belongs_to :user
	belongs_to :service

	validates :start_at, presence: true, comparison: { less_than: :end_at }
	validates :end_at, presence: true

	# This is method is used to create and update an availability
	def self.upsert(availability, id)

		# get the service and user
		service = Service.find(availability[:service_id])
		user = User.find(availability[:user_id])
		
		# check if the service is active
		return ErrorUtilities::generate_custom_error("service_id", "Service is inactive") unless service.active

		
		# create new datetime object with user's start_at and end_at
		start_at = DateTime.parse(availability[:start_at])
		end_at = DateTime.parse(availability[:end_at])

		# verify if start_at and end_at are in the same day
		return ErrorUtilities::generate_custom_error("start_at", "start_at #{start_at.to_date} is not the same day as end_at #{end_at.to_date}") unless start_at.day == end_at.day

		# check if the availability is in the past
		return ErrorUtilities::generate_custom_error("date", "User cannot create or chage an availability if it is in the past") if start_at < DateTime.now

		# check if the availability is for today
		return ErrorUtilities::generate_custom_error("start_at", "User can't create or change an availability for today") if start_at.to_date == Date.current

		
		
		# get day of the week of end_at
		day_of_week_for_availability = start_at.strftime("%A").downcase
		
		# filter the service days by day_of_week_for_availability
		service_shifts_for_selected_day = service.shifts.where(day: day_of_week_for_availability)
		
		# id nil means that this excution is for create
		if id.nil?
			# check if the user has availability in the same day and service 
			check_availabilities_in_same_day = Availability.where(user_id: user.id, service_id: service.id).where("(extract(isodow from availabilities.start_at)) - 1 = ?", Shift.days[day_of_week_for_availability])

			return ErrorUtilities::generate_custom_error("start_at", "User already has an availability for this service in the same day") if check_availabilities_in_same_day.count > 0
		end

		# verify if the service has a shift on the day of the week for availability
		return ErrorUtilities::generate_custom_error("service_id", "for service with id #{service.id} not exist a shift for date #{start_at.to_date}") if (service_shifts_for_selected_day.count).zero?

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

		# if all validations are ok, destroy previous availability and create a new one
		prev_availability = Availability.find(id) unless id.nil?
		prev_availability.destroy if prev_availability.present?

		availability = Availability.new(availability)
	end

	def self.get_availabilities_by_users(availabilities)
		availabilities_by_users = availabilities.group_by { |availability| availability.user_id }

		availabilities_by_users = availabilities_by_users.map do |user_id, availabilities|
			
			total_availability_hours = availabilities.reduce(0) { |sum, availability| 
				sum + ((availability.end_at - availability.start_at) / 1.hour)
			}

			{
				user_id: user_id,
				total_availabilities: availabilities.count,
				total_availability_hours: total_availability_hours,
			}
		end
	end

	def self.get_availabilities_by_day(availabilities, shifts)

		total_hours_by_shift = shifts.map do |shift|
			{
				day: shift.day,
				total_hours: (shift.end_time.to_time - shift.start_time.to_time) / 1.hour,
				end_time: shift.end_time,
				start_time: shift.start_time
			}
		end

		availabilities_by_days = availabilities.group_by { |availability| availability.start_at.strftime("%A").downcase }

		availabilities_by_days = availabilities_by_days.map do |day, availabilities|
			
			current_shift = total_hours_by_shift.find { |shift| shift[:day] == day }

			availabilities = availabilities.map do |availability|

				total_hours = (availability.end_at - availability.start_at) / 1.hour

				{
					id: availability.id,
					user_id: availability.user_id,
					total_available_hours: total_hours,
					missing_hours: current_shift[:total_hours] - total_hours,
					day: current_shift[:day],
					date: availability.start_at.strftime("%Y-%m-%d"),
					availability_start_at: availability.start_at.strftime("%H:%M"),
					availability_end_at: availability.end_at.strftime("%H:%M"),
					shift_start_at: current_shift[:start_time],
					shifts_end_at: current_shift[:end_time]
				}
			end

			# sort availabilities by missing hours in ascending order
			availabilities = availabilities.sort_by { |availability| availability[:missing_hours] }

			{
				day: day,
				target_shift_hours: current_shift[:total_hours],
				availabilities: availabilities
			}

		
		end
	end

	def self.get_availabilities_by_week(availabilities, shifts)
		# group availabilities by week 
		availabilities_by_week = availabilities.group_by { |availability| availability.start_at.beginning_of_week..availability.start_at.end_of_week }

		# total hours by shift
		total_shift_hours_for_week = shifts.reduce(0) { |sum, shift|
			hours_per_day = shift.end_time.split(":")[0].to_i - shift.start_time.split(":")[0].to_i
			sum + hours_per_day
		}
		

		# count availabilities by week
		availabilities_by_week = availabilities_by_week.map do |week, availabilities|
			{
				week: week,
				total_availabilites: availabilities.count,
				total_shift_hours_for_week: total_shift_hours_for_week,
				availabilities_by_days: get_availabilities_by_day(availabilities, shifts),
				availabilities_by_user: get_availabilities_by_users(availabilities)
			}
		end
	end

	# by passing current_date and shift we can get the following object:
	# {
	# 	"start_time": "2022-12-25 08:00",
	# 	"end_time": "2022-12-25 16:00"
	# }
	def self.generate_date_for_availability(current_date, shift)
		shift_start_time = shift[:start_time].split(":").first.to_i
		shift_end_time = shift[:end_time].split(":").first.to_i
		shift_day = shift[:day]
	
		availavility_start_time = rand(shift_start_time..(shift_end_time - 1))
		availavility_end_time = rand((availavility_start_time + 1)..shift_end_time)
		availavility_day = current_date.strftime("%A").downcase
		# format start_time and end_time to "HH:MM"
		start_time = "#{current_date.strftime("%Y-%m-%d")} #{availavility_start_time}:00"
		end_time = "#{current_date.strftime("%Y-%m-%d")} #{availavility_end_time}:00"
		
		unless availavility_day == shift_day
			raise "Availability day #{availavility_day} is not the same as shift day #{shift_day}"
		end
		
		{
			start_time: start_time,
			end_time: end_time
		}
	end

	private
	def execute_assignments
		# Assignment.assign(self)
	end

end
