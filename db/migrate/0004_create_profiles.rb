class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
	  t.string :color
      t.string :phone, null: true
      t.integer :role
      t.datetime :deleted_at, default: nil, null: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
