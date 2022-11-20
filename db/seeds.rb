# Using faker to generate fake data
require "faker"

User.create({
    first_name: "Alejandro", 
    last_name: "Dubon",
    role: "admin",
    email: "alejandrodubon88@gmail.com", 
    password: "123456", 
    password_confirmation: "123456"
}).save


5.times do
    password = "helloworld123"
    User.create(
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
    ).save
end