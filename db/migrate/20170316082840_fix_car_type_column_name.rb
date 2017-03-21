class FixCarTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :cars, :type, :category
  end
end
