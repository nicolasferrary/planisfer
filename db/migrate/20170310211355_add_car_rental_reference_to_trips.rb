class AddCarRentalReferenceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :car_rental, foreign_key: true
  end
end
