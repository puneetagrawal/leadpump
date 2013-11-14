class GmailFriend < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :active, :secret_token, :user_id
  belongs_to :user

  before_create :generate_token

  def self.getName(contact, email)
  	name = ''
  	if contact.name != ''
  		name = contact.name
	else
		name = email != '' ? email.split("@")[0] : ''
    name = name != '' ? name.gsub(/[^0-9a-z ]/i, '') : ''
	end 
  end



  protected

  def generate_token
	  random_token = SecureRandom.urlsafe_base64(nil, false)
	  self.secret_token = random_token
  end


end
