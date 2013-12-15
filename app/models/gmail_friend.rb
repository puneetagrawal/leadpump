class GmailFriend < ActiveRecord::Base
	attr_accessible :email, :name, :opt_in, :secret_token, :sent, :user_id, :visited, :oppened, :source
	belongs_to :user
	
	after_create :generate_token

	def self.getName(contact, email)
		name = ''
		if !contact.blank? && contact.name != ''
			name = contact.name
		else
			name = email != '' ? email.split("@")[0] : ''
			name = name != '' ? name.gsub(/[^0-9a-z ]/i, '') : ''
		end 
	end

	def self.savegmailContact(contacts, user)
		contacts.each do |contact|
			email = contact.email != '' ? contact.email : ''
			name = GmailFriend.getName(contact,email)
			if email.present? && name.present?
				gmailcontact = GmailFriend.where(:user_id => user.id, :email => email, :source=>"gmail")
				if !gmailcontact.present?
					gmailfreind = GmailFriend.create(:name=>name, :email=>email, :user_id=>user.id, :source=>"gmail")
					gmailfreind.save
				end
			end
		end
	end

	def self.saveyahooContact(contacts, user)
		contacts.each do |contact|
			 unless contact[:email].blank? 
		        email = contact[:email] != '' ? contact[:email] : ''
				name = GmailFriend.getName('', email)
				if email.present? && name.present?
					yahoocontact = GmailFriend.where(:user_id => user.id, :email => email, :source=>"yahoo")
					if !yahoocontact.present?
						gmailfreind = GmailFriend.create(:name=>name, :email=>email, :user_id=>user.id, :source=>"yahoo")
						gmailfreind.save
					end
				end
			end
		end
	end

	protected

	def generate_token
		token = SecureRandom.urlsafe_base64(self.id, false)
		self.secret_token = token[0, 10]
		self.save
	end

end
