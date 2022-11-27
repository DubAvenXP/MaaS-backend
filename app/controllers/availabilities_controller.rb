class AvailabilitiesController < ApplicationController
	before_action :set_availability, only: %i[ show destroy ]

	# GET /availabilities
	def index
	end 

	# GET /availabilities/1
	def show
	end

	# POST /availabilities
	def create
		availability_responder(nil, :created, nil)
	end

	# PATCH/PUT /availabilities/1
	def update
		availability_responder(params.dig(:id), :ok, nil)
	end

	# DELETE /availabilities/1
	def destroy
		availability_responder(params.dig(:id), :ok, "delete")
	end

	private

	def availability_responder(id, status, action)
		
		if action == "delete"
			availability = Availability.availability_manager(nil, id, action)
			return respond_with_success(Assignment.assign(@availability.service.id), status)
		end

		availability = Availability.availability_manager(availability_params, id, action)

		# custom validations
		return respond_with_custom_errors(availability) if availability[:errors].present? 

		if availability.save
			respond_with_success(Assignment.assign(availability.service_id), status)
		else
			respond_with_errors(availability)
		end
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_availability
		@availability = Availability.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def availability_params
		params.require(:availability).permit(:start_at, :end_at, :user_id, :service_id)
	end
end
