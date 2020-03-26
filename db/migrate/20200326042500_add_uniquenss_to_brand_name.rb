class AddUniquenssToBrandName < ActiveRecord::Migration[5.2]
  def change
    add_index :brands, :name, unique: true
  end
end
