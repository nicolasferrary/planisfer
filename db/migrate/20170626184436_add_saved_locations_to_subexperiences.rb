class AddSavedLocationsToSubexperiences < ActiveRecord::Migration[5.0]
  def change
    add_column :subexperiences, :saved_locations, :string
  end
end
