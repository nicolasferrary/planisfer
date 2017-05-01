class AddDescriptionToRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :description, :string
  end
end
