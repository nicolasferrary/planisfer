class AddNbTravelersToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :nb_travelers, :integer
  end
end
