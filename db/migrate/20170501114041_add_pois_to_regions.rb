class AddPoisToRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :pois, :text, array: true, default: []
  end
end
