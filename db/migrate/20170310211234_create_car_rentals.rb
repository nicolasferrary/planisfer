class CreateCarRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :car_rentals do |t|
      t.float :price
      t.string :currency
      t.string :pick_up_location
      t.string :drop_off_location
      t.datetime :pick_up_date_time
      t.datetime :drop_off_date_time
      t.integer :driver_age
      t.string :company
      t.references :car, foreign_key: true
      t.string :deep_link_url

      t.timestamps
    end
  end
end
