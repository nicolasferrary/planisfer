class AddSippColumnToCars < ActiveRecord::Migration[5.0]
  def change
    add_column :cars, :sipp, :string
  end
end
