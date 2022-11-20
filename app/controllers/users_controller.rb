class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    render json: User.index
  end

  def show
    render json: @user.show
  end

  def create
    @user = User.create(user_params)

    if @user[:errors].present?
      render json: @user[:errors], status: :unprocessable_entity
      return
    end

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
  end
end
