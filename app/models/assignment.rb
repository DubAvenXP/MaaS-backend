class Assignment < ApplicationRecord
	belongs_to :user
	belongs_to :shift


	def self.assign(params)
		
		service = Service.find(params[:service_id])
		shifts = service.shifts

		# not assign availabilities if they are less than today
		availabilities = service.availabilities.where("availabilities.start_at >= ?", Date.today)
		# group availabilities by week 
		availabilities_by_week = Availability.get_availabilities_by_week(availabilities, shifts)

		# iterate over shifts
		# service.shifts.each do |shift|

		# 	# shift_availabilities = service.availabilities.joins(:user).joins(user: :profile).select("
		# 	# 	availabilities.id, availabilities.start_at, availabilities.end_at,
		# 	# 	users.id as user_id, 
		# 	# 	concat(profiles.first_name, ' ', profiles.last_name) as user_name
		# 	# ")

		# 	# get availabilities for this shift where the availabilities are greater or equal than today
		# 	# shift_availabilities = service.availabilities
		# 	# 	.where("availabilities.start_at >= ?", Date.today)

		# 	availabilities_by_week = service.availabilities.group_by { |availability| 
		# 		# start week and end week
		# 		availability.start_at.beginning_of_week..availability.start_at.end_of_week
		# 	}
			

		# 	# get availability per day (23-11-2022 and 30-11-2022)
		# 		# .where("availabilities.start_at >= ?", Date.today)
		# 		# .where("(extract(isodow from availabilities.start_at)) - 1 = ?", Shift.days[shift.day]) # where day of week of availability is the same that shift.day
		# 		# .joins(:user).joins(user: :profile)
			
		# 	availabilities_counter = shift_availabilities.count
			
		# 	# group availabilities by users
		# 	# group_users_by_availabilities = shift_availabilities.group_by(&:user_id) # [ "1": [ availability1, availability2 ], "2": [ availability3, availability4 ] ]
			
			
		{
			availabilities_by_week: availabilities_by_week
		}

		# TODO: don't try to assign to past days and past hours



		# count availabilties for this shift
		

		# count availabilties by user in that shift



		# get every availability
		# filter by day availabilities


		# TODO: try to assign to every user same hours
		# TODO: avoid shift changes by day
		
		# 2

		# TODO: after create an assignment update the availability


		# 3

		# TODO: calculate pending hours by shift
		# TODO: calculate assigned_shift by user
		# TODO: recommend what user should be assigned to pending hours by shift
	end


	private



end
