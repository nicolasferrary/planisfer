class RenameTravelersColumnInSearches < ActiveRecord::Migration[5.0]
  def change
    rename_column :searches, :nb_travelers, :nb_adults
    add_column :searches, :nb_children, :integer
    add_column :searches, :nb_infants, :integer
  end
end
