class CreateAirports < ActiveRecord::Migration[5.0]
  def change
    create_table :airports do |t|
      t.string :name
      t.string :iata
      t.references :city, foreign_key: true
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
