class AddCategoryAndCarNameToCarRentals < ActiveRecord::Migration[5.0]
  def change
    add_column :car_rentals, :category, :string
    add_column :car_rentals, :car_name, :string
    remove_reference :car_rentals, :car, foreign_key: true
  end
end
