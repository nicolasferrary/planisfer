class AddCoordinatesToRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :latitude_arrive, :float
    add_column :round_trip_flights, :longitude_arrive, :float
    add_column :round_trip_flights, :latitude_back, :float
    add_column :round_trip_flights, :longitude_back, :float
  end
end
