class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
	  t.boolean :active, default: true
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :deleted_at
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
