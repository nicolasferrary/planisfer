class AddRoundTripFlightReferenceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :round_trip_flight, foreign_key: true
  end
end
