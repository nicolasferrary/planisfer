class RemoveDescriptionFromPois < ActiveRecord::Migration[5.0]
  def change
    remove_column :pois, :description
  end
end
