class RemovePricesFromTrips < ActiveRecord::Migration[5.0]
  def change
    remove_column :trips, :price, :float
  end
end
