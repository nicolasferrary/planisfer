class RemoveCityReferenceFromTrips < ActiveRecord::Migration[5.0]
  def change
    remove_reference :trips, :city, foreign_key: true
    add_column :trips, :city, :string
  end
end
