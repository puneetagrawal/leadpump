class AddSourceToGmailFriend < ActiveRecord::Migration
  def change
    add_column :gmail_friends, :source, :string
  end
end
