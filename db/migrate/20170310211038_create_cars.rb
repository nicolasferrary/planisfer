class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :type
      t.integer :doors
      t.integer :seats
      t.string :image_url

      t.timestamps
    end
  end
end
