class RemoveRangeFromSearch < ActiveRecord::Migration[5.0]
  def change
    remove_column :searches, :range
  end
end
