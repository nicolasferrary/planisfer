class AddRegionReferenceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :region, foreign_key: true
  end
end
