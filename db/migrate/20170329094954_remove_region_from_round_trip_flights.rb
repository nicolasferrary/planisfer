class RemoveRegionFromRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    remove_column :round_trip_flights, :region, :string
  end
end
