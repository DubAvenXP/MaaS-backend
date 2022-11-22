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

	private

	def is_valid_client_id
		# validate if client_id exists
		errors.add("Invalid client id provided") unless Client.find(self.client_id).present?
	end

	def is_valid_date
		verify_date_regex = /^(\d{4})(\-)(0?[1-9]|1[012])(\-)(0?[1-9]|[12][0-9]|3[01])$/

		start_at = self.start_at.to_s.split[0]
		end_at = self.end_at.to_s.split[0]

		errors.add(:start_at, "Date must be formatted correctly") unless end_at.match(verify_date_regex)
		errors.add(:end_at, "Date must be formatted correctly") unless start_at.match(verify_date_regex)
		puts "hello world #{start_at.match(verify_date_regex)}"
		puts "hello world #{"2022-11-22".match(verify_date_regex)}"
		puts "hello world #{start_at.class}"
		puts "hello world"
		puts "hello world"
		puts "hello world #{end_at.match(verify_date_regex)}"
		puts "hello world"
	end
end
