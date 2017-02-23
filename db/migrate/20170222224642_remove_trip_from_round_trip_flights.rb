class RemoveTripFromRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    remove_column :round_trip_flights, :trip_id, :integer
  end
end
