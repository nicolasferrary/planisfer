class AddFeedbackToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :feedback, :text, array: true, default: []
  end
end
