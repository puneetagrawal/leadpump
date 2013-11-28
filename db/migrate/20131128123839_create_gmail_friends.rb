class CreateGmailFriends < ActiveRecord::Migration
  def change
    create_table :gmail_friends do |t|
      t.string :email
      t.string :name
      t.integer :user_id
      t.boolean :visited, :default=>false
      t.boolean :opt_in, :default=>false
      t.boolean :sent, :default=>false
      t.string :secret_token
      t.boolean :oppened, :default=>false

      t.timestamps
    end
  end
end
