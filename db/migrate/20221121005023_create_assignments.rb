class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :deleted_at
      t.references :user, null: false, foreign_key: true
      t.references :shift, null: false, foreign_key: true
      t.references :availability, null: true, foreign_key: true

      t.timestamps
    end
  end
end
