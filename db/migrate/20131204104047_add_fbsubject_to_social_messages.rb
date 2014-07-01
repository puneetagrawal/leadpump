class AddFbsubjectToSocialMessages < ActiveRecord::Migration
  def change
    add_column :social_messages, :fbsubject, :string
    add_column :social_messages, :gmailsubject, :string
  end
end
