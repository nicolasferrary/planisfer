class AddBagsToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :bags, :integer
  end
end
