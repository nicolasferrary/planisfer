class RemoveActivityreferenceFromSubexperiences < ActiveRecord::Migration[5.0]
  def change
    remove_reference :subexperiences, :activity, foreign_key: true
  end
end
