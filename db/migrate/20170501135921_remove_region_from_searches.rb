class RemoveRegionFromSearches < ActiveRecord::Migration[5.0]
  def change
    remove_column :searches, :region
  end
end
