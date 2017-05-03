class AddCitynameToAirport < ActiveRecord::Migration[5.0]
  def change
    add_column :airports, :cityname, :string
  end
end
