
Service.all.each do |service| 
	current_date = (Date.current + 1.week).beginning_of_week
	next_month = current_date + 6.week

	puts "Service with id #{service.id} start at #{service.start_at} and end at #{service.end_at}"

	# iterate over current_date to next_month for one service
	while current_date < next_month

		
		# find the shift for the current_date and service
		shift = service.shifts.find_by(day: current_date.strftime("%A").downcase)
		
		puts "Starting with date #{current_date.strftime("%A").downcase} #{current_date}"
		puts "Current shift: #{shift[:day]} #{shift[:start_time]} - #{shift[:end_time]}"


		User.all.each do |user| # iterate 6 times
			availability = Availability.generate_date_for_availability(current_date, shift)
			
			
			puts "Availability created for #{user.email} in service id #{service.id} from #{availability[:start_time]} to #{availability[:end_time]}\n"
			
			begin
				# create and save availability
				Availability.upsert({
					start_at: availability[:start_time],
					end_at: availability[:end_time],
					user_id: user.id,
					service_id: service.id
				}, nil).save!
			rescue => exception
				# get availability
				error_availability = Availability.find_by(start_at: availability[:start_time], user_id: user.id, service_id: service.id)
			end

		end
			
		# when create availability, pass to the next day
		current_date = current_date + 1.day

		puts "passing to new date (#{current_date})\n\n"
	end
end

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
