class CreateSocialMessages < ActiveRecord::Migration
  def change
    create_table :social_messages do |t|
      t.string :facebookMessage
      t.string :twitterMessage
      t.string :gmailMessage
      t.integer :company_id

      t.timestamps
    end
  end
end
