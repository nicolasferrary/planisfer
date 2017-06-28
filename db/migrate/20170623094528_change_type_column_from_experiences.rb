class ChangeTypeColumnFromExperiences < ActiveRecord::Migration[5.0]
  def change
    remove_column :experiences, :type, :string
  end
end
