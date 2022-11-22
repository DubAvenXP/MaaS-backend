class AvailabilitiesController < ApplicationController
	before_action :set_availability, only: %i[ show update destroy ]

	# GET /availabilities
	def index
		renspond_with_success(Availability.all)
	end

	# GET /availabilities/1
	def show
		renspond_with_success(@availability)
	end

	# POST /availabilities
	def create
		@availability = Availability.new(availability_params)

		if @availability.save
			respond_with_success(@availability, :created)
		else
			respond_with_errors(@availability)
		end
	end

	# PATCH/PUT /availabilities/1
	def update
		if @availability.update(availability_params)
			respond_with_success(@availability)
		else
			respond_with_errors(@availability)
		end
	end

	# DELETE /availabilities/1
	def destroy
		@availability.destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_availability
		@availability = Availability.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def availability_params
		params.require(:availability).permit(:start_at, :end_at, :deleted_at, :user_id)
	end
end
