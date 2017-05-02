class AddAirportsToRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :airports, :text, array: true, default: []
  end
end
