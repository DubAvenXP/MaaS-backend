class Service < ApplicationRecord
	belongs_to :client
	
	has_many :shifts, dependent: :destroy
	has_many :availabilities, dependent: :destroy
	
	validate :is_valid_client_id
	validate :is_valid_date

	validates :name, presence: true, length: 5..100
	validates :description, presence: true, length: 5..250
	validates :start_at, presence: true, comparison: { less_than: :end_at, greater_or_equal_than: Date.current }
	validates :end_at, presence: true

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


	# after create an availability or assignment
	# verify if the service is still valid
	def verify_services_status
		# get 

	end


	private

	# validate if client_id exists
	def is_valid_client_id
		errors.add("Invalid client id provided") unless Client.find(self.client_id).present?
	end

	# validate if date is valid
	def is_valid_date
		errors.add(:start_at, "Must be formatted correctly") unless self.start_at.class == ActiveSupport::TimeWithZone
		errors.add(:end_at, "Must be formatted correctly") unless self.end_at.class == ActiveSupport::TimeWithZone
	end

	
end
