class AddSearchReferenceToTrip < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :search, foreign_key: true
  end
end
