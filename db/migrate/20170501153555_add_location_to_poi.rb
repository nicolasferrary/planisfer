class AddLocationToPoi < ActiveRecord::Migration[5.0]
  def change
    add_column :pois, :location, :string
  end
end
