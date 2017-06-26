class ChangeSavedLocationsName < ActiveRecord::Migration[5.0]
  def change
    rename_column :subexperiences, :saved_locations, :saved_location
  end
end
