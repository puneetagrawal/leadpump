class SendIvitationToGmailFriend < ActiveRecord::Base
  attr_accessible :email, :name, :user_id
  belogns_to :user
end
