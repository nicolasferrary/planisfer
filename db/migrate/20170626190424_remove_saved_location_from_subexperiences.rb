class RemoveSavedLocationFromSubexperiences < ActiveRecord::Migration[5.0]
  def change
    remove_column :subexperiences, :saved_location, :string
  end
end
