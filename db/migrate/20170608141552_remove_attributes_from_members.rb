class RemoveAttributesFromMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :first_name, :string
    remove_column :members, :name, :string
  end
end
