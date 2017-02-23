class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :city
      t.string :region
      t.date :starts_on
      t.date :returns_on

      t.timestamps
    end
  end
end
