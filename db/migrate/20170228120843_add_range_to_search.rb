class AddRangeToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :range, :string
  end
end
