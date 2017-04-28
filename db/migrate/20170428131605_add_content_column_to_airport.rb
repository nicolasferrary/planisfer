class AddContentColumnToAirport < ActiveRecord::Migration[5.0]
  def change
    add_column :airports, :content, :string
  end
end
