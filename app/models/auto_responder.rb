class AutoResponder < ActiveRecord::Base
  attr_accessible :message, :respond_date, :subject, :user_id, :user_lead, :day
  belongs_to :user
  def self.saveResponder(respond,user)
  	respond.user_id = user.id
  	respond.save
  end

end
