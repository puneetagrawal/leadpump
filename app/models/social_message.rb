class SocialMessage < ActiveRecord::Base
  attr_accessible :company_id, :facebookMessage, :gmailMessage, :twitterMessage
  belongs_to :user
end
