# Using faker to generate fake data
require "faker"

# Seed for users

User.create({
    first_name: "Alejandro", 
    last_name: "Dubon",
    role: "admin",
    email: "alejandrodubon88@gmail.com", 
    password: "123456", 
    password_confirmation: "123456"
}).save

puts "\n===========================================\n"

puts "User #{User.first.email} created"

5.times do
    password = "helloworld123"
    user = User.create(
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
    )

    user.save
    puts "User #{user.email} created"
end

puts "\n===========================================\n"

# Seed for clients

client_names = ["Hospital San Jose", "Panaderia Lupita", "Cafeteria La Esquina", "Recorrido.cl"]

client_names.length.times do
    client = Client.new({
        name: client_names.shift,
        description: Faker::Lorem.paragraph
    })

    client.save
    puts "Client #{client.name} created"
end

puts "\n===========================================\n"

# seed for services

clients = Client.all

service_names = [
    "Monitoreo de funcionalidades", 
    "Monitoreo Applicacion web",
    "Monitoreo Applicacion movil",
    "Monitoreo Applicacion de Escritorio",
    "Monitoreo Instalaciones",
    "Monitoreo de Redes",
    "Monitoreo de Servidores",
    "Monitoreo de Base de Datos",
]

clients.each do |client|

    start_at = Date.current
    end_at   = start_at + rand(1..3).months

    rand(1..2).times do
        client.services.create({
            name: service_names.shift,
            description: Faker::Lorem.paragraph,
            start_at: start_at,
            end_at: end_at
        }).save
    end

    puts "Services for client '#{client.name}' were created"
end

puts "\n===========================================\n"

# seed for shifts

services = Service.all

services.each do |service|

    puts "\n\n"

    Shift.days.each do |day|
        start_time = rand(8..12)
        end_time = start_time + rand(3..10)
    
        # format start_time and end_time to "HH:MM"
        start_time = "0#{start_time}" if start_time < 10
        start_time = "#{start_time}:00"
    
        end_time = "0#{end_time}" if end_time < 10
        end_time = "#{end_time}:00"
        

        puts "Creating shift for service '#{service.name}' on day '#{day[0]}' from #{start_time} to #{end_time}"

        service.shifts.create({
            day: Shift.days[day[0]],
            start_time: start_time,
            end_time: end_time,
        }).save
    end

    puts "\nShifts for service '#{service.name}' were created"

end 
