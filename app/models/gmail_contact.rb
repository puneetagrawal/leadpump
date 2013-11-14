class GmailContact < ActiveRecord::Base
  attr_accessible :email, :name, :active, :secret_token, :phone, :user_id
  belongs_to :user
end
