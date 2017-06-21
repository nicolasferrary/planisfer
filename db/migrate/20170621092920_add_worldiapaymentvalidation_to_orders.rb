class AddWorldiapaymentvalidationToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :worldiapaymentvalidation, :boolean
  end
end
