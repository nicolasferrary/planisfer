class RenameAirportColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :airports, :type, :category
  end
end
