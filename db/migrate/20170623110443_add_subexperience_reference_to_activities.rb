class AddSubexperienceReferenceToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :subexperience, foreign_key: true
  end
end
