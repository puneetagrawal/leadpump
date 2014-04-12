class AutoResponder < ActiveRecord::Base
  attr_accessible :message, :respond_date, :subject, :user_id, :user_lead, :day
  belongs_to :user
  def self.saveResponder(respond,user, from_email)
  	user.from_email = from_email
  	user.save
  	respond.user_id = user.id
  	respond.from_email = from_email
  	respond.save
  end

end
