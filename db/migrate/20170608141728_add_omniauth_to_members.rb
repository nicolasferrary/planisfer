class AddOmniauthToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :provider, :string
    add_column :members, :uid, :string
    add_column :members, :facebook_picture_url, :string
    add_column :members, :first_name, :string
    add_column :members, :last_name, :string
    add_column :members, :token, :string
    add_column :members, :token_expiry, :datetime
  end
end
