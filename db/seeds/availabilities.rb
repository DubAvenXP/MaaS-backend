first_service = Service.first
second_service = Service.last

current_date = (Date.current + 1.week).beginning_of_week
next_month = current_date + 6.week

puts "Service with id #{first_service.id} start at #{first_service.start_at} and end at #{first_service.end_at}"
users = User.limit(5)
# iterate over current_date to next_month for one service
while current_date < next_month

	
	# find the shift for the current_date and service
	shift = first_service.shifts.find_by(day: current_date.strftime("%A").downcase)
	
	
	
	users.each do |user| # iterate 6 times
		availability = Availability.generate_date_for_availability(current_date, shift)
		
		
		
		begin
			# create and save availability
			Availability.availability_manager({
				start_at: availability[:start_time],
				end_at: availability[:end_time],
				user_id: user.id,
				service_id: first_service.id
				}, nil, nil).save!
				
			puts "Starting with date #{current_date.strftime("%A").downcase} #{current_date}"
			puts "Current shift: #{shift[:day]} #{shift[:start_time]} - #{shift[:end_time]}"
			puts "Availability created for #{user.email} in service id #{first_service.id} from #{availability[:start_time]} to #{availability[:end_time]}\n"
		rescue => exception
			# get availability
		end

	end
		
	# when create availability, pass to the next day
	current_date = current_date + 1.day
end

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"

current_date = (Date.current + 1.week).beginning_of_week
next_month = current_date + 6.week

puts "Service with id #{first_service.id} start at #{first_service.start_at} and end at #{first_service.end_at}"
users = User.offset(5).limit(5)
# iterate over current_date to next_month for one service
while current_date < next_month

	
	# find the shift for the current_date and service
	shift = first_service.shifts.find_by(day: current_date.strftime("%A").downcase)

	users.each do |user| # iterate 6 times
		availability = Availability.generate_date_for_availability(current_date, shift)
		
		begin
			# create and save availability
			Availability.availability_manager({
				start_at: availability[:start_time],
				end_at: availability[:end_time],
				user_id: user.id,
				service_id: first_service.id
				}, nil, nil).save!

			puts "Starting with date #{current_date.strftime("%A").downcase} #{current_date}"
			puts "Current shift: #{shift[:day]} #{shift[:start_time]} - #{shift[:end_time]}"
			puts "Availability created for #{user.email} in service id #{first_service.id} from #{availability[:start_time]} to #{availability[:end_time]}\n"
		rescue => exception
			# get availability
		end

	end
		
	# when create availability, pass to the next day
	current_date = current_date + 1.day
end

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"


# current_date = (Date.current + 1.week).beginning_of_week
# next_month = current_date + 5.week

# puts "Service with id #{second_service.id} start at #{second_service.start_at} and end at #{second_service.end_at}"

# # iterate over current_date to next_month for one service
# while current_date < next_month

	
# 	# find the shift for the current_date and service
# 	shift = second_service.shifts.find_by(day: current_date.strftime("%A").downcase)
	
# 	puts "Starting with date #{current_date.strftime("%A").downcase} #{current_date}"
# 	puts "Current shift: #{shift[:day]} #{shift[:start_time]} - #{shift[:end_time]}"


# 	User.limit(5).offset(5).each do |user| # iterate 6 times
# 		availability = Availability.generate_date_for_availability(current_date, shift)
		
		
		
# 		begin
# 			# create and save availability
# 			Availability.availability_manager({
# 				start_at: availability[:start_time],
# 				end_at: availability[:end_time],
# 				user_id: user.id,
# 				service_id: second_service.id
# 				}, nil, nil).save!
# 				puts "Availability created for #{user.email} in service id #{second_service.id} from #{availability[:start_time]} to #{availability[:end_time]}\n"
# 			rescue => exception
# 			# get availability
# 			error_availability = Availability.find_by(start_at: availability[:start_time], user_id: user.id, service_id: second_service.id)
			
# 		end

# 	end
		
# 	# when create availability, pass to the next day
# 	current_date = current_date + 1.day

# 	puts "passing to new date (#{current_date})\n\n"
# end
