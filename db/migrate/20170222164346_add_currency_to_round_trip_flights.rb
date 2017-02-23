class AddCurrencyToRoundTripFlights < ActiveRecord::Migration[5.0]
  def change
    add_column :round_trip_flights, :currency, :string
  end
end
