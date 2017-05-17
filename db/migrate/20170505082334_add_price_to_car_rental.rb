class AddPriceToCarRental < ActiveRecord::Migration[5.0]
  def change
    add_monetize :car_rentals, :price, currency: { present: false }
  end
end
