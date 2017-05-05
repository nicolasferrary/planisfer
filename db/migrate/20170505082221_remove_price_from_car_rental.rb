class RemovePriceFromCarRental < ActiveRecord::Migration[5.0]
  def change
    remove_column :car_rentals, :price, :float
  end
end
