class AddRegionToRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :region, :string
  end
end
