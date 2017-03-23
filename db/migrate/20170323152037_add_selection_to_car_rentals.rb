class AddSelectionToCarRentals < ActiveRecord::Migration[5.0]
  def change
    add_reference :car_rentals, :selection, foreign_key: true
  end
end
