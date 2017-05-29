class DropCities < ActiveRecord::Migration[5.0]
  def change
    drop_table :cities
  end
end
