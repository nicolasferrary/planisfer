class AddF1NumberToRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :f1_number, :string
    add_column :round_trip_flights, :f2_number, :string
  end
end
