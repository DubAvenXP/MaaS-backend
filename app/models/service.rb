class Service < ApplicationRecord
	belongs_to :client
	
	has_many :shifts, dependent: :destroy
	has_many :availabilities, dependent: :destroy


	def show
		shifts = self.shifts.map do |shifts|
			{
				id: shifts.id,
				start_time: shifts.start_time,
				end_time: shifts.end_time,
				day: shifts.day

			}
		end
		
		{
			id: self.id,
			name: self.name,
			description: self.description,
			start_at: self.start_at,
			end_at: self.end_at,
			shifts: shifts
		}
	end
end
