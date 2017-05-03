class RemoveRegionReferenceFromAirports < ActiveRecord::Migration[5.0]
  def change
    remove_column :airports, :region
  end
end
