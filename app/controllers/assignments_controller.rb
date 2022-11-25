class AssignmentsController < ApplicationController
	before_action :set_assignment, only: %i[ show update destroy ]

	# GET /assignments
	def index
		respond_with_success(Assignment.all)
	end

	# GET /assignments/1
	def show
		respond_with_success(@assignment)
	end

	# POST /assignments
	def create
		@assignment = Assignment.assign(params)

		respond_with_success(@assignment)
	end

	# PATCH/PUT /assignments/1
	def update
		if @assignment.update(assignment_params)
			respond_with_success(@assignment)
		else
			respond_with_errors(@assignment)
		end
	end

	# DELETE /assignments/1
	def destroy
		@assignment.destroy
	end

	private
	
	# Use callbacks to share common setup or constraints between actions.
	def set_assignment
		@assignment = Assignment.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def assignment_params
		params.require(:assignment).permit(:start_at, :end_at, :deleted_at, :user_id, :shift_id)
	end
end
