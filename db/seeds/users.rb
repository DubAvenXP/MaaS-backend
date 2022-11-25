
# Seed for users


# Main user

User.all.each do |user|
	user.destroy
end

User.create({
    first_name: "Alejandro", 
    last_name: "Dubon",
    role: "admin",
    email: "alejandrodubon88@gmail.com", 
    password: "123456", 
    password_confirmation: "123456"
}).save

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"

puts "User #{User.first.email} created"

# Random users

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

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
