class AddServiceIdToAvailability < ActiveRecord::Migration[7.0]
	def change
		add_reference :availabilities, :service, foreign_key: true
	end
end
