class CreateGmailFriends < ActiveRecord::Migration
  def change
    create_table :gmail_friends do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.boolean :active, :default => false
      t.string :secret_token
      t.integer :user_id
      t.timestamps
    end
  end
end
