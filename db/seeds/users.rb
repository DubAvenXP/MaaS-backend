
# Seed for users
password = "helloworld123"
colors = [
	'#E5D9B6',
	'#A4BE7B',
	'#F2C94C',
	'#F2994A',
	'#CEE5D0',
	'#2F80ED',
	'#E6E5A3',
	'#BF8B67',
	'#DB6B97',
	'#9B51E0',
	'#7FC8A9',
	'#CA8A8B',
]

# Main user

# destroy all users
User.destroy_all

User.create({
	first_name: "Alejandro", 
    last_name: "Dubon",
    role: "admin",
    email: "alejandrodubon88@gmail.com", 
    password: password, 
    password_confirmation: password,
	color: colors.pop
}).save!

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"

puts "User #{User.first.email} created"

# Random users

10.times do
    user = User.create(
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
		color: colors.pop,
    )
    user.save!
end


puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
