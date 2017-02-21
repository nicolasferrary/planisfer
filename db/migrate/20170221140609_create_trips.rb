class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.float :price
      t.date :starts_on
      t.date :returns_on
      t.integer :nb_travelers
      t.references :city, foreign_key: true
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
