class RemoveCountryFromCity < ActiveRecord::Migration[5.0]
  def change
    remove_column :cities, :country, :string
  end
end
