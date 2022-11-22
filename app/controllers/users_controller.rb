class UsersController < ApplicationController
	before_action :set_user, only: %i[show update destroy]

	# GET /users
	def index
		respond_with_success(User.index)
	end

	# GET /users/1
	def show
		respond_with_success(@user.show)
	end

	# POST /users
	def create
		@user = User.create(user_params)

		
		# custom validations
		return respond_with_errors(@user) if @user[:errors].present? 
		
		if @user.save
			respond_with_success(@user, :created)
		else
			respond_with_errors(@user)
		end
	end

	# PATCH/PUT /users/1
	def update
		if @user.update(user_params)
			respond_with_success(@user.show)
		else
			respond_with_errors(@user)
		end
	end

	# DELETE /users/1
	def destroy
		@user.destroy
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_user
		@user = User.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
	end
end
