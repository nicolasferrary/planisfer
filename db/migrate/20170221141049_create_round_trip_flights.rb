class CreateRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    create_table :round_trip_flights do |t|
      t.float :price
      t.string :flight1_origin_airport_iata
      t.string :flight1_destination_airport_iata
      t.string :flight2_origin_airport_iata
      t.string :flight2_destination_airport_iata
      t.datetime :flight1_landing_at
      t.datetime :flight1_take_off_at
      t.datetime :flight2_take_off_at
      t.datetime :flight2_landing_at
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
