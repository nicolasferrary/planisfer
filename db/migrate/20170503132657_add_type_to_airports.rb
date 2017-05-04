class AddTypeToAirports < ActiveRecord::Migration[5.0]
  def change
      add_column :airports, :type, :string
  end
end
