class AddStatusToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :profile_status, :integer
  end
end
