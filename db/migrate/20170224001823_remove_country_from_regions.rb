class RemoveCountryFromRegions < ActiveRecord::Migration[5.0]
  def change
    remove_column :regions, :country, :string
  end
end
