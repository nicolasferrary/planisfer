class ChangePriceForRtf < ActiveRecord::Migration[5.0]
  def change
    remove_column :round_trip_flights, :price, :float
    add_monetize :round_trip_flights, :price, currency: { present: false }
  end
end
