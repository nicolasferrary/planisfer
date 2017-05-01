class CreatePois < ActiveRecord::Migration[5.0]
  def change
    create_table :pois do |t|
      t.string :name
      t.string :photo
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
