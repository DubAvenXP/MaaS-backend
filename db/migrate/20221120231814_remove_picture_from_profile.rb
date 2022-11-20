class RemovePictureFromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :picture, :string
  end
end
