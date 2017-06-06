class AddMemberReferenceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :member, foreign_key: true, index: true
  end
end
