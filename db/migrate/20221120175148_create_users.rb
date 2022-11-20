class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :is_confirmed, default: false, null: false
      t.datetime :confirmed_at, default: nil, null: true
      t.datetime :deleted_at, default: nil, null: true
      
      t.timestamps
    end
  end
end
