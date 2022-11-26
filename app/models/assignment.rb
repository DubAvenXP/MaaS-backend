class Assignment < ApplicationRecord
	belongs_to :user
	belongs_to :shift
	belongs_to :availability, optional: true

	def self.assign(params)

		service = Service.find(params[:service_id])
		shifts = service.shifts

		# not assign availabilities if they are less than today
		availabilities = service.availabilities.joins(user: :profile).joins(:user).where("availabilities.start_at >= ?", Date.today.beginning_of_day)

		# group availabilities by week
		availabilities_by_week = Availability.get_availabilities_by_week(availabilities, shifts)

		potential_assignments = []
		
		# iterate over each week
		availabilities_by_week.each do |week|
			potential_assignments <<  get_best_assignments_by_week(week)
		end

		# 2

		# TODO: after create an assignment update the availabilities for that day in


		# 3

		# TODO: calculate pending hours by shift
		# TODO: calculate assigned_shift by user
		# TODO: recommend what user should be assigned to pending hours by shift

		# TODO: if user has been assigned to a shift, update the availability for the other services at the same time
		# TODO: if the availability runs out of hours, turn it off

		

		{ total_weeks: availabilities_by_week.count, potential_assignments: potential_assignments }
	end

	def self.potential_assignments(service_id, week)

		

		service = Service.find(params[:service_id])
		shifts = service.shifts

		# not assign availabilities if they are less than today
		availabilities = service.availabilities.joins(user: :profile).joins(:user).where("availabilities.start_at >= ?", Date.today.beginning_of_day)

		# group availabilities by week
		availabilities_by_week = Availability.get_availabilities_by_week(availabilities, shifts)

		potential_assignments = []
		
		# iterate over each week
		availabilities_by_week.each do |week|
			potential_assignments <<  get_best_assignments_by_week(week)
		end

		{ total_weeks: availabilities_by_week.count, potential_assignments: potential_assignments }
	end

	private

	def self.get_best_assignments_by_week(week)
		# total assigned hours by user
		assigned_users = {}
		# best assignments for the week
		assignments_for_week = []

		# total_shift_hours_by_week = week[:total_shift_hours_by_week]
		potential_average_user_hours_by_week = week[:potential_average_user_hours_by_week]

		# iterate over each day
		week[:availabilities_by_days].each do |day|
			best_assignments_day = get_potential_assignments_by_day(day, assigned_users, potential_average_user_hours_by_week)
			best_assignment = nil

			# 1. add the best assignments if for the first day
			if assignments_for_week.empty?
				
				assignment = best_assignments_day[:potential_assignments].first
				assignments_for_week << assignment
				assigned_users = calculate_assigned_user_stats(assignment, assigned_users)
				best_assignment = assignment
				puts "First assignment found"
				next
			end
			
			
			# 2. iterate over best_assignments and pick the best one
			# the best one has and array of recommended provided by each user
			counter = 0
			bad_assignments = [] # { index: x, total_recommendations: y }

			while counter < best_assignments_day[:potential_assignments].count

				potential_assignment = best_assignments_day[:potential_assignments][counter]

				# if all the values in array of recommended are true, then it is the best assignment
				if potential_assignment[:array_of_recommendations].all?
					assignments_for_week << potential_assignment
					assigned_users = calculate_assigned_user_stats(potential_assignment, assigned_users)
					best_assignment = potential_assignment
					counter = best_assignments_day[:potential_assignments].count
				else
					bad_assignments << {
						index: counter,
						# total_recommendations will be used to sort bad_assignments 
						total_recommendations: potential_assignment[:array_of_recommendations].count(true)
					}
				end
				counter += 1
			end

			next unless best_assignment.nil?

			# verify if there is a best assignment
			
			# if there is no best assignment, then pick the one with the most recommendations
			bad_assignments = bad_assignments.sort_by { |bad_assignment| bad_assignment[:total_recommendations] }
			
			best_assignment = best_assignments_day[:potential_assignments][bad_assignments.last[:index]]
			assignments_for_week << best_assignment
			assigned_users = calculate_assigned_user_stats(best_assignment, assigned_users)
		end
		formatted_users = []
		assigned_users.each do |user_id, user_stats|
			formatted_users << {
				user_id: user_id,
				assigned_hours: user_stats[:assigned_hours],
			}
		end

		real_average_user_hours_by_week = formatted_users.reduce(0) { |sum, user| sum + user[:assigned_hours] } / formatted_users.count
		
		{
			week: week[:week],
			potential_average_user_hours_by_week: potential_average_user_hours_by_week,
			real_average_user_hours_by_week: real_average_user_hours_by_week,
			assert_percentage: (real_average_user_hours_by_week / potential_average_user_hours_by_week) * 100,
			assigned_users: formatted_users,
			assignments_for_week: assignments_for_week,
		}
	end

	# this method is used to generate the best assignments for a day and recommend the best assignments
	# The potential assignments are sorted by shift changes
	# {
	# 	day: day_availabilities[:day],
	# 	best_assignments: [{} ... {}]
	# }
	def self.get_potential_assignments_by_day(day_availabilities, assigned_users = {}, average_hours = 0)

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
					day: day_availabilities[:day],
					has_shift_changes: false,
					total_shift_changes: 0,
					is_complete: true,
					availabilities: [availability],
					array_of_missing_hours: [],
					array_of_recommendations: [recommended]
				}
				next
			end

			# check missing hours
			if best_assignments.count > 0 && !best_assignments.last[:is_complete] && best_assignments.last[:array_of_missing_hours].count > 0
				# check if the current availability can complete the last best assignment

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
				missing_hours = array_of_missing_hours.delete_if { |e| hours_to_assign.include?(e) }
				
				# add relevant to the availability
				availability[:assignment_start_at] = format_time(assignment_start_at)
				availability[:assignment_end_at] = format_time(assignment_end_at)
				availability[:total_assigned_hours] = get_total_hours(availability[:assignment_start_at], availability[:assignment_end_at])
				
				# add assignment to last.best_assignments
				best_assignments.last[:day] = day_availabilities[:day]
				best_assignments.last[:is_complete] = missing_hours.count == 0
				best_assignments.last[:array_of_missing_hours] = missing_hours
				best_assignments.last[:availabilities] << availability
				best_assignments.last[:total_shift_changes] += 1
				best_assignments.last[:array_of_recommendations] << recommended

				next
			end
			
			
			# if the last best assignment is complete, add a new one
			# this availability has missing hours
			if availability[:missing_hours] > 0
				
				availability[:assignment_start_at] = availability[:availability_start_at]
				availability[:assignment_end_at] = availability[:availability_end_at]
				availability[:total_assigned_hours] = get_total_hours(availability[:assignment_start_at], availability[:assignment_end_at])

				best_assignments << {
					day: day_availabilities[:day],
					has_shift_changes: true,
					total_shift_changes: 1,
					is_complete: false,
					availabilities: [availability],
					array_of_missing_hours: get_array_of_missing_hours(availability),
					array_of_recommendations: [recommended]
				}
			end
		end

		{
			day: day_availabilities[:day],
			potential_assignments: best_assignments
		}
	end

	# get array of missing hours from availability
	def self.get_array_of_missing_hours(availability)
		array_of_hours_shift = get_array_of_hours(availability[:shift_start_at], availability[:shift_end_at])
		array_of_hours_availabilitiy = get_array_of_hours(availability[:availability_start_at], availability[:availability_end_at])

		missing_hours = (array_of_hours_shift + array_of_hours_availabilitiy).difference(array_of_hours_availabilitiy)
		missing_hours
	end

	# get array of hours from start_at to end_at
	# example: start_at = 10, end_at = 12
	# return [10, 11, 12]
	def self.get_array_of_hours(start_at, end_at)
		formatted_start_at = start_at.split(":")[0].to_i
		formatted_end_at = end_at.split(":")[0].to_i
		array_of_hours = (formatted_start_at..formatted_end_at).to_a
		array_of_hours.pop
		array_of_hours
	end

	# format time to 24 hours
	# 10 -> 10:00
	def self.format_time(time)
		# format time to "HH:MM"
		return time = "0#{time}:00" if time < 10
		time = "#{time}:00" unless time < 10
	end

	# get total hours between two times
	def self.get_total_hours(start_time, end_time)
		# get total hours of shift
		start_time = start_time.split(":")[0].to_i
		end_time = end_time.split(":")[0].to_i

		end_time - start_time
	end

	# { user_id: { assigned_hours: x }  }
	# returns a hash with the user_id and the total assigned hours
	def self.calculate_assigned_user_stats(potential_assignment, assigned_users)
		potential_assignment[:availabilities].each do |availability|

			# unless the user is already in the hash, add it
			unless assigned_users[availability[:user_id]].present?
				assigned_users[availability[:user_id]] = {
					assigned_hours: availability[:total_assigned_hours],
					user_full_name: availability[:user_full_name]
				}
				next
			end

			# if the user is already in the hash, add the assigned hours to the previous total
			assigned_users[availability[:user_id]][:assigned_hours] += availability[:total_assigned_hours]
		end

		assigned_users
	end


end
