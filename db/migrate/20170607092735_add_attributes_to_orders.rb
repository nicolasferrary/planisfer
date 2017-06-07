class AddAttributesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :question, :text
    add_column :orders, :passengers, :text
  end
end
