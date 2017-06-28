class CreateSubexperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :subexperiences do |t|
      t.references :experience, foreign_key: true
      t.references :poi, foreign_key: true
      t.integer :rating
      t.string :review
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
