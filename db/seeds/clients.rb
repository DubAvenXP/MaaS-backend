client_names = [ "Recorrido.cl", "Hospital San Jose"]

client_names.each do |name|
    client = Client.new({
        name: name,
        description: Faker::Lorem.paragraph
    })

    client.save
    puts "Client #{client.name} created"
end

puts "\n*  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  *  -  \n"
