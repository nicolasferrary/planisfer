class AddColumnToAirports < ActiveRecord::Migration[5.0]
  def change
    add_column :airports, :coordinates, :string
  end
end
