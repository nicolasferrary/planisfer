class AddRecosToMembers < ActiveRecord::Migration[5.0]
  def change
      add_column :members, :recos, :text, array: true, default: []
  end
end
