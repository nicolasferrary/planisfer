class AddCarriersToRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :carrier1, :string
    add_column :round_trip_flights, :carrier2, :string
  end
end
