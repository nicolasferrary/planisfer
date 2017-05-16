class AddArrivalCityToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :arrival_city, :string
    add_column :trips, :return_city, :string
  end
end
