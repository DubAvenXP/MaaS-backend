class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.string :start_time
      t.string :end_time
      t.integer :day
      t.boolean :active
      t.datetime :deleted_at
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
