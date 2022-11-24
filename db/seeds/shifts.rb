# seed for shifts
Service.all.each do |service|
    Shift.days.keys.each do |day|

		start_time = rand(1..12)
        end_time = start_time + rand(1..12)
    
        # format start_time and end_time to "HH:MM"
        start_time = "0#{start_time}" if start_time < 10
        start_time = "#{start_time}:00"
    
        end_time = "0#{end_time}" if end_time < 10
        end_time = "#{end_time}:00"
        
        shift = service.shifts.new({
            day: day,
            start_time: start_time,
            end_time: end_time,
        })

		unless shift.save
			puts "Shift #{shift.errors.full_messages}"
		end
    end
end 

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
