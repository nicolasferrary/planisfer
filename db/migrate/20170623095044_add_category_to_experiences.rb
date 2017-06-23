class AddCategoryToExperiences < ActiveRecord::Migration[5.0]
  def change
    add_column :experiences, :category, :text, array: true, default: []
  end
end
