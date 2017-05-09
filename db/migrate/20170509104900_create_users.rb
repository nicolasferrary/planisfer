class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :mail
      t.string :first_name
      t.string :name
      t.string :phone
      t.string :call_time
      t.text :passengers

      t.timestamps
    end
  end
end
