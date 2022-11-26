class Service < ApplicationRecord
	belongs_to :client
	
	has_many :shifts, dependent: :destroy
	has_many :availabilities, dependent: :destroy
	has_many :assignments, dependent: :destroy
	
	# custom validations
	validate :is_valid_client_id
	validate :is_valid_date
	
	# validations
	validates :name, presence: true, length: 5..100
	validates :description, presence: true, length: 5..250
	validates :start_at, presence: true, comparison: { less_than: :end_at, greater_or_equal_than: Date.current }
	validates :end_at, presence: true

	# this method shows the service with their associated shifts
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
			start_at: self.start_at.to_date,
			end_at: self.end_at.to_date,
			shifts: shifts,
		}
	end


	# after create an availability or assignment
	# verify if the service is still valid

	# this method returns the availabilities by service
	def get_availabilities_by_service(params)

		# check if week is present and parse to DateTime
		week = DateTime.parse(params[:week]) if params[:week].present?

		# if week is not available then use the current week
		week = Time.current.beginning_of_week if week.nil?
		next_week = week + 1.week
		prev_week = week - 1.week

		# get the availabilities of the service
		availabilities = self.availabilities.joins(:user).joins(user: :profile).select("
			availabilities.id, availabilities.start_at, availabilities.end_at, availabilities.assigned, availabilities.active,
			users.id as user_id, 
			concat(profiles.first_name, ' ', profiles.last_name) as user_name, profiles.color
		")

		# filter availabilities by week
		availabilities = availabilities.where(start_at: week.beginning_of_week..week.end_of_week)
	
		# group the availabilities by day
		availabilities = availabilities.group_by { |availability| availability.start_at.strftime("%A").downcase }

		# get shifts for the current service
		shifts = self.shifts.select("id, day, start_time, end_time")

		# format the shifts
		shifts = shifts.map do |shift|
			{
				id: shift.id,
				day: shift.day,
				start_time: shift.start_time,
				end_time: shift.end_time,
				availabilities: availabilities[shift.day] || []
			}
		end
		

		service = {
			id: self.id,
			name: self.name,
			start_at: self.start_at.to_date,
			end_at: self.end_at.to_date,
			current_week: week.to_date,
			next_week: next_week.to_date,
			prev_week: prev_week.to_date,
			shifts: shifts
		}

		service
	end

	def assignments_by_service(params)
		# check if week is present and parse to DateTime
		week = DateTime.parse(params[:week]) if params[:week].present?

		# if week is not available then use the current week
		week = Time.current.beginning_of_week if week.nil?
		next_week = week + 1.week
		prev_week = week - 1.week

		# get the availabilities of the service
		assignments = self.assignments.joins(:user).joins(user: :profile).select("
			assignments.id, assignments.start_at, assignments.end_at,
			users.id as user_id, 
			concat(profiles.first_name, ' ', profiles.last_name) as user_name, profiles.color
		")

		# filter assignments by week
		assignments_week = Assignment.show(self, week)

		service = {
			id: self.id,
			name: self.name,
			start_at: self.start_at.to_date,
			end_at: self.end_at.to_date,
			current_week: week.to_date,
			next_week: next_week.to_date,
			prev_week: prev_week.to_date,
			assignments: assignments_week[:assignments_by_week],
		}

		service
	end

	def potential_assignments_by_service(params)
		
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
