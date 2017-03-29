class AddColumnToRoundTripFlight < ActiveRecord::Migration[5.0]
  def change
    add_reference :round_trip_flights, :region, foreign_key: true
  end
end
