class RemoveUserReferenceFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_reference :orders, :user, foreign_key: true
  end
end
