class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.references :member, foreign_key: true
      t.references :region, foreign_key: true
      t.string :type
      t.integer :rating
      t.integer :cost
      t.integer :length
      t.string :tip

      t.timestamps
    end
  end
end
