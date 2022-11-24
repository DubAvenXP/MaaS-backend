Rails.application.routes.draw do


	resources :assignments
	resources :shifts

	resources :services do
		member do
			get  "assignments"
			get  "availabilities"
		end
	end
	

	resources :clients
	resources :availabilities, only: %i[create update destroy]
	resources :profiles, only: %i[update]
	resources :users

end
