class AvailabilitiesController < ApplicationController
	before_action :set_availability, only: %i[ show destroy ]

	# GET /availabilities
	def index
		respond_with_success(Availability.all)
	end

	# GET /availabilities/1
	def show
		respond_with_success(@availability)
	end

	# POST /availabilities
	def create
		upsert(nil, :created)
	end

	# PATCH/PUT /availabilities/1
	def update
		upsert(params.dig(:id), :ok)
	end

	# DELETE /availabilities/1
	def destroy
		@availability.destroy
	end

	private

	def upsert(id, status)
		@availability = Availability.upsert(availability_params, id)

		# custom validations
		return respond_with_custom_errors(@availability) if @availability[:errors].present? 

		if @availability.save
			respond_with_success(@availability, status)
		else
			respond_with_errors(@availability)
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
