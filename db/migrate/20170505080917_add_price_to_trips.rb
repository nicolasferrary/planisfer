class AddPriceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_monetize :trips, :price, currency: { present: false }
  end
end
