

current_date = Date.current + 2.days
next_month = current_date + 6.week

Service.all.each do |service|
	puts "Service with id #{service.id} start at #{service.start_at} and end at #{service.end_at}"
	users = User.limit(5)
	# iterate over current_date to next_month for one service
	while current_date < next_month

		
		# find the shift for the current_date and service
		shift = service.shifts.find_by(day: current_date.strftime("%A").downcase)
		
		
		
		users.each do |user| # iterate 6 times
			availability = Availability.generate_date_for_availability(current_date, shift)
			
			
			
			begin
				# create and save availability
				Availability.availability_manager({
					start_at: availability[:start_time],
					end_at: availability[:end_time],
					user_id: user.id,
					service_id: service.id
					}, nil, nil).save!
					
				puts "Starting with date #{current_date.strftime("%A").downcase} #{current_date}"
				puts "Current shift: #{shift[:day]} #{shift[:start_time]} - #{shift[:end_time]}"
				puts "Availability created for #{user.email} in service id #{service.id} from #{availability[:start_time]} to #{availability[:end_time]}\n"
			rescue => exception
				# get availability
			end

		end
			
		# when create availability, pass to the next day
		current_date = current_date + 1.day
	end

end


Service.all.each do |service|
	Assignment.assign(service.id)
	puts "Assignments created for service id #{service.id}"
end

Service.create({
	name: "Monitoreo Servidores",
	description: Faker::Lorem.paragraph,
	start_at: Date.current + 2.days,
	end_at: Date.current + 2.days + 2.months,
	client_id: Client.first.id
}).save

Shift.days.keys.each do |day|

	start_time = rand(1..12)
	end_time = start_time + rand(1..12)

	# format start_time and end_time to "HH:MM"
	start_time = "0#{start_time}" if start_time < 10
	start_time = "#{start_time}:00"

	end_time = "0#{end_time}" if end_time < 10
	end_time = "#{end_time}:00"
	
	shift = Service.last.shifts.new({
		day: day,
		start_time: start_time,
		end_time: end_time,
	})

	unless shift.save
		puts "Shift #{shift.errors.full_messages}"
	end
end

puts "Last Service created"

