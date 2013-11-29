class GmailFriend < ActiveRecord::Base
	attr_accessible :email, :name, :opt_in, :secret_token, :sent, :user_id, :visited, :oppened
	belongs_to :user
	
	after_create :generate_token

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
		token = SecureRandom.urlsafe_base64(self.id, false)
		self.secret_token = token
		self.save
	end

end
