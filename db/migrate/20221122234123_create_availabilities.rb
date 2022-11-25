class CreateAvailabilities < ActiveRecord::Migration[7.0]
	def change
		create_table :availabilities do |t|
		t.datetime :start_at
		t.datetime :end_at
		t.datetime :deleted_at
		t.boolean  :assigned, default: false
		t.boolean  :active, default: true
		t.references :user, null: false, foreign_key: true
		t.references :service, null: false, foreign_key: true

		t.timestamps
		end
	end
end
