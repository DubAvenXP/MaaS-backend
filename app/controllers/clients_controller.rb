class ClientsController < ApplicationController
	before_action :set_client, only: %i[ show update destroy ]

	# GET /clients
	def index
		respond_with_success(Client.all)
	end

	# GET /clients/1
	def show
		respond_with_success(@client)
	end

	# POST /clients
	def create
		@client = Client.new(client_params)

		if @client.save
		respond_with_success(@client, :created)
		else
		respond_with_errors(@user)
		end
	end

	# PATCH/PUT /clients/1
	def update
		if @client.update(client_params)
			respond_with_success(@client)
		else
			respond_with_errors(@client)
		end
	end

	# DELETE /clients/1
	def destroy
		@client.destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_client
		@client = Client.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def client_params
		params.require(:client).permit(:name, :description)
	end
end
