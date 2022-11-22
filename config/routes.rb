Rails.application.routes.draw do


	resources :assignments
	resources :shifts

	resources :services do
		collection do
			post "assign"
			get  "assignments"
		end
	end
	

	resources :clients
	resources :availabilities
	resources :profiles, only: %i[update]
	resources :users

end
