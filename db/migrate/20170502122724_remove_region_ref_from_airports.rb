class RemoveRegionRefFromAirports < ActiveRecord::Migration[5.0]
  def change
    remove_reference :airports, :region, foreign_key: true
  end
end
