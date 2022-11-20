class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ update ]

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      render json: @profile.user.show
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone, :picture, :role)
    end
end
