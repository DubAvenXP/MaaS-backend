
# seed for services

clients = Client.all

clients.each do |client|
	start_at = Date.current + 2.days
	start_at = start_at.beginning_of_week
	end_at   = start_at + 2.months

	client.services.create({
		name: "Monitoreo Aplicaciones moviles",
		description: Faker::Lorem.paragraph,
		start_at: start_at,
		end_at: end_at
	}).save

	puts "Service #{client.services.first.name} created"
end

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
