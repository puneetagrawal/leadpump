class CreateSendIvitationToGmailFriends < ActiveRecord::Migration
  def change
    create_table :send_ivitation_to_gmail_friends do |t|
      t.string :name
      t.string :email
      t.integer :user_id

      t.timestamps
    end
  end
end
