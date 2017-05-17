class AddSkuToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :sku, :string
  end
end
