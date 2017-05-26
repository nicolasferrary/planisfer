class RenameTravelersColumnIn < ActiveRecord::Migration[5.0]
  def change
    rename_column :trips, :nb_travelers, :nb_adults
    add_column :trips, :nb_children, :integer
    add_column :trips, :nb_infants, :integer
  end
end
