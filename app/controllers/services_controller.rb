class ServicesController < ApplicationController
	before_action :set_service, only: %i[ show update destroy availabilities assignments ]

	# GET /services
	def index
		respond_with_success(Service.index)
	end

	# GET /services/1
	def show
		respond_with_success(@service.show)
	end

	# POST /services
	def create
		@service = Service.new(service_params)

		if @service.save
			respond_with_success(@service, :created)
		else
			respond_with_errors(@service)
		end
	end

	# PATCH/PUT /services/1
	def update
		if @service.update(service_params)
			respond_with_success(@services)
		else
			respond_with_errors(@service)
		end
	end

	# DELETE /services/1
	def destroy
		@service.destroy
	end

	# GET /services/1/availabilities
	def availabilities
		respond_with_success(@service.get_availabilities_by_service(params))
	end

	# GET /services/1/assignments
	def assignments
		respond_with_success(@service.assignments_by_service(params))
	end

	private
	
	# Use callbacks to share common setup or constraints between actions.
	def set_service
		@service = Service.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def service_params
		params.require(:service).permit(:name, :description, :start_at, :end_at, :client_id)
	end
end
