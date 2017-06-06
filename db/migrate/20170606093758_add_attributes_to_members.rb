class AddAttributesToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :first_name, :string
    add_column :members, :name, :string
    add_column :members, :question, :text
    add_column :members, :passengers, :text
  end
end
