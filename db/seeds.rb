# Using faker to generate fake data
require "faker"

load "db/seeds/users.rb"
load "db/seeds/clients.rb"
load "db/seeds/services.rb"
load "db/seeds/shifts.rb"
load "db/seeds/availabilities.rb"

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
puts "#{User.all.count} users created"
puts "#{Client.all.count} clients created"
puts "#{Service.all.count} services created"
puts "#{Shift.all.count} shifts created"
puts "#{Availability.all.count} availabilities created"
puts "#{Assignment.all.count} assignments created"
puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
