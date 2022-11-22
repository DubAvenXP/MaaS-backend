class ShiftsController < ApplicationController
	before_action :set_shift, only: %i[ show update destroy ]

	# GET /shifts
	def index
		respond_with_success(Shift.all)
	end

	# GET /shifts/1
	def show
		respond_with_success(@shift)
	end

	# POST /shifts
	def create
		@shift = Shift.new(shift_params)

		if @shift.save
			respond_with_success(@shift, :created)
		else
			respond_with_errors(@shift)
		end
	end

	# PATCH/PUT /shifts/1
	def update
		if @shift.update(shift_params)
			respond_with_success(@shift)
		else
			respond_with_errors(@shift)
		end
	end

	# DELETE /shifts/1
	def destroy
		@shift.destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_shift
		@shift = Shift.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def shift_params
		params.require(:shift).permit(:start_time, :end_time, :day, :service_id)
	end
end
