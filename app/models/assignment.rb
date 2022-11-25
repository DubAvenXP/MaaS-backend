class Assignment < ApplicationRecord
	belongs_to :user
	belongs_to :shift
	belongs_to :availability, optional: true


	def self.assign(params)

		service = Service.find(params[:service_id])
		shifts = service.shifts

		# not assign availabilities if they are less than today
		availabilities = service.availabilities.where("availabilities.start_at >= ?", Date.today)

		# group availabilities by week
		availabilities_by_week = Availability.get_availabilities_by_week(availabilities, shifts)

		availabilities_to_assign = []
		assigned_users = {}

		# iterate over each week
		availabilities_by_week.each do |week|
			# # when user completes their average hours, they are not assigned anymore
			# completed_average_users = {
			# 	# user_id: { assigned_hours: x, missing_hours: y, availabilty_hours: z }
			# }


			assignments_for_week = []

			# assign monday then recalculate the best assignments for tuesday
			# assign tuesday then recalculate the best assignments for wednesday
			# ...

			# total_shift_hours_by_week = week[:total_shift_hours_by_week]
			average_user_hours_by_week = week[:average_user_hours_by_week]

			# iterate over each day
			week[:availabilities_by_days].each do |day|
				best_assignments_day = calculate_best_assignments(day, assigned_users, average_user_hours_by_week)

				# add the best assignments for the day to the assignments for the week
				if assignments_for_week.empty?
					assignments = best_assignments_day[:potential_assignments][0]
					assignments_for_week << assignments
					assigned_users = calculate_assigned_user_stats(assignments, assigned_users)
				end

				assignments_for_week << best_assignments_day


				# mark as inactive the rest of availabilities
				# mark as active the rest of availabilities
				# fill the array with assigned users
			end

			availabilities_to_assign << assignments_for_week
		end




		# count availabilties for this shift


		# count availabilties by user in that shift



		# get every availability
		# filter by day availabilities


		# TODO: try to assign to every user same hours
		# TODO: avoid shift changes by day

		# 2

		# TODO: after create an assignment update the availabilities for that day in


		# 3

		# TODO: calculate pending hours by shift
		# TODO: calculate assigned_shift by user
		# TODO: recommend what user should be assigned to pending hours by shift

		# TODO: if user has been assigned to a shift, update the availability for the other services at the same time
		# TODO: if the availability runs out of hours, turn it off


		{
			# availabilities_by_week: availabilities_by_week
			availabilities_to_assign: availabilities_to_assign,
			assigned_users: assigned_users
		}
	end


	private


	# TODO: return this function to get best assignments_by_service (frontend)
	# this method is used to calculate the best assignments for a day
	# are sorted by shift changes
	# {
	# 	day: day_availabilities[:day],
	# 	best_assignments: [{} ... {}]
	# }

	# { 
	# 	user_id: {
	# 		assigned_hours: x, 
	# 	}
	# }
	def self.calculate_best_assignments(day_availabilities, assigned_users = {}, average_hours = 0)

		best_assignments = []
		
		day_availabilities[:availabilities].each do |availability|
			
			user_stats = assigned_users[availability[:user_id]] || {}
			recommended = user_stats[:assigned_hours] < average_hours if user_stats[:assigned_hours].present?
			recommended = true unless user_stats[:assigned_hours].present?

			# if availability has 0 missing hours, add it to the best assignments and then skip it
			if availability[:missing_hours] == 0
				
				availability[:assignment_start_at] = availability[:availability_start_at]
				availability[:assignment_end_at] = availability[:availability_end_at]
				availability[:total_assigned_hours] = get_total_hours(availability[:assignment_start_at], availability[:assignment_end_at])

				best_assignments << {
					has_shift_changes: false,
					total_shift_changes: 0,
					is_complete: true,
					availabilities: [availability],
					array_of_recommended: [recommended],
					array_of_missing_hours: []
				}
				next
			end

			# check missing hours
			if best_assignments.count > 0 && !best_assignments.last[:is_complete] && best_assignments.last[:array_of_missing_hours].count > 0
				# chech if the current availability can complete the last best assignment

				# get array of hours of current availability
				array_of_hours_availabilitiy = get_array_of_hours(availability[:availability_start_at], availability[:availability_end_at])

				# get array of missing hours of last best assignment
				array_of_missing_hours = best_assignments.last[:array_of_missing_hours]

				# verify if array_of_hours_availabilitiy contains some of the missing hours
				duplicated_hours = (array_of_hours_availabilitiy + array_of_missing_hours)

				# the duplicated hours are the missing hours
				hours_found = duplicated_hours.find_all { |e| duplicated_hours.rindex(e) != duplicated_hours.index(e) }.uniq

				# if hours are 0 skip this availability
				next if hours_found.count == 0

				# sort the hours found
				hours_found = hours_found.sort { |a, b| a <=> b }

				# only get the hours that are consecutive from array
				hours_to_assign = hours_found.slice_when { |prev, curr| curr != prev.next }.to_a # [[10, 11], [16], [19, 20, 21]]
				
				# pick greatest consecutive hours
				hours_to_assign = hours_to_assign.max_by(&:length)
				
				assignment_start_at = hours_to_assign.first
				assignment_end_at = hours_to_assign.last == assignment_start_at ? assignment_start_at + 1 : hours_to_assign.last
				
				# get the new missing hours
				# transform [[10, 11], [16]] to [10, 11, 16]
				missing_hours = duplicated_hours.difference(hours_found).count <= 1 ? [] : duplicated_hours.difference(hours_found)
				
				# if it does, add the availability to the availabilities arrrat on last best assignment

				# add assignment to availability
				availability[:assignment_start_at] = format_time(assignment_start_at)
				availability[:assignment_end_at] = format_time(assignment_end_at)
				availability[:total_assigned_hours] = get_total_hours(availability[:assignment_start_at], availability[:assignment_end_at])

				best_assignments.last[:is_complete] = missing_hours.count == 0
				best_assignments.last[:array_of_missing_hours] = missing_hours
				best_assignments.last[:availabilities] << availability
				best_assignments.last[:total_shift_changes] << best_assignments.last[:availabilities].count - 1
				best_assignments.last[:array_of_recommended] << recommended
				next
			end


			# if the last best assignment is complete, add a new one
			# this availability has missing hours
			if availability[:missing_hours] > 0
				
				availability[:assignment_start_at] = availability[:availability_start_at]
				availability[:assignment_end_at] = availability[:availability_end_at]
				availability[:total_assigned_hours] = get_total_hours(availability[:assignment_start_at], availability[:assignment_end_at])

				best_assignments << {
					has_shift_changes: true,
					total_shift_changes: 1,
					is_complete: false,
					availabilities: [availability],
					array_of_missing_hours: get_array_of_missing_hours(availability),
					array_of_recommended: [recommended]
				}
			end
		end

		{
			day: day_availabilities[:day],
			potential_assignments: best_assignments
		}
	end

	def self.get_array_of_missing_hours(availability)
		array_of_hours_shift = get_array_of_hours(availability[:shift_start_at], availability[:shift_end_at])
		array_of_hours_availabilitiy = get_array_of_hours(availability[:availability_start_at], availability[:availability_end_at])

		# merge and quit duplicates
		missing_hours = (array_of_hours_shift + array_of_hours_availabilitiy).difference(array_of_hours_availabilitiy)
	end

	def self.get_array_of_hours(start_at, end_at)
		formatted_start_at = start_at.split(":")[0].to_i
		formatted_end_at = end_at.split(":")[0].to_i

		array_of_hours = (formatted_start_at..formatted_end_at).to_a
	end

	def self.format_time(time)
		# format time to "HH:MM"
		return time = "0#{time}:00" if time < 10
		time = "#{time}:00" unless time < 10
	end

	def self.get_total_hours(start_time, end_time)
		# get total hours of shift
		start_time = start_time.split(":")[0].to_i
		end_time = end_time.split(":")[0].to_i

		end_time - start_time
	end

	def self.calculate_assigned_user_stats(assignments, assigned_users)
		assignments[:availabilities].each do |availability|
			if assigned_users.blank?
				assigned_users[availability[:user_id]] = {
					assigned_hours: availability[:total_assigned_hours]
				} 
			elsif assigned_users[availability[:user_id]].present?
				assigned_users[availability[:user_id]][:assigned_hours] += availability[:total_assigned_hours]
			end
		end
		assigned_users
	end


end
