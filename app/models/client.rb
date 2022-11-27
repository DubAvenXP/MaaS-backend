class Client < ApplicationRecord
    has_many :services, dependent: :destroy

    validates :name, presence: true, length: 5..100
	validates :description, presence: true, length: 5..250


	def self.index()
		clients = Client.all
		clients = clients.map do |client|
			services = client.services.map do |service|
				{
					id: service.id,
					name: service.name,
					description: service.description,
					shifts: service.shifts
				}
			end

			{
				id: client.id,
				name: client.name,
				description: client.description,
				services: services
			}
		end
		
		clients
	end

end
