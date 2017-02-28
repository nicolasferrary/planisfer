class AddFlight1RangeToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :flight1_range, :string
    add_column :searches, :flight2_range, :string
  end
end
