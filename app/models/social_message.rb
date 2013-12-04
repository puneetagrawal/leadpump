class SocialMessage < ActiveRecord::Base
  attr_accessible :company_id, :facebookMessage, :gmailMessage, :twitterMessage, :gmailsubject, :fbsubject
  belongs_to :user
end
