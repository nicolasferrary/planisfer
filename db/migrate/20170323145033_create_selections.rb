class CreateSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :selections do |t|

      t.timestamps
    end
  end
end
