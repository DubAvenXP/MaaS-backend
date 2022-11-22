class ProfilesController < ApplicationController
    before_action :set_profile, only: %i[ update ]

    # PATCH/PUT /profiles/1
    def update
		if @profile.update(profile_params)
			respond_with_success(@profile.user.show)
		else
			respond_with_errors(@profile)
		end
    end

    private
	# Use callbacks to share common setup or constraints between actions.
	def set_profile
		@profile = Profile.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def profile_params
		params.require(:profile).permit(:first_name, :last_name, :phone, :image, :role)
	end
end
