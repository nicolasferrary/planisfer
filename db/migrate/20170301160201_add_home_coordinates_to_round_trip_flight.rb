class AddHomeCoordinatesToRoundTripFlight < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :latitude_home, :float
    add_column :round_trip_flights, :longitude_home, :float
  end
end
