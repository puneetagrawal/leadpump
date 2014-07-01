class AddAccessTokenToGmailFriends < ActiveRecord::Migration
  def change
    add_column :gmail_friends, :access_token, :string
  end
end
