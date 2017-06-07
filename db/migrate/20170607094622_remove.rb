class Remove < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :question, :text
    remove_column :members, :passengers, :text
  end
end
