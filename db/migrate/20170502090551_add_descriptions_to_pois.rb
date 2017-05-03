class AddDescriptionsToPois < ActiveRecord::Migration[5.0]
  def change
    add_column :pois, :description1, :string
    add_column :pois, :description2, :string
    add_column :pois, :description3, :string
    add_column :pois, :description4, :string
    add_column :pois, :description5, :string
  end
end
