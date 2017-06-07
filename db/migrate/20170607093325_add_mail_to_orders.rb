class AddMailToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :mail, :string
  end
end
