class RemoveRegionRefFromTrips < ActiveRecord::Migration[5.0]
  def change
    remove_reference :trips, :region, foreign_key: true
  end
end
