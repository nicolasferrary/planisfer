class RemoveCityReferenceFromAirport < ActiveRecord::Migration[5.0]
  def change
    remove_reference :airports, :city, foreign_key: true
  end
end
