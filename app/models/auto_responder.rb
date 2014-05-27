class AutoResponder < ActiveRecord::Base
  attr_accessible :message, :respond_date, :subject, :user_id, :user_lead, :day
  
  translates :message, :subject

  belongs_to :user
  def self.saveResponder(respond,user, from_email)
  	user.from_email = from_email
  	user.save
  	respond.user_id = user.id
  	respond.save
  end

  def self.create_charge_for_trail_user
	  logger.debug("Creating charge for trial users --- #{Date.today}")
	  trial_user = Subscription.where("expiry_date < ?",Date.today)
	  if trial_user.present?
	    logger.debug(trial_user.size)
	    logger.debug("ddddddddddddddddddddddddddddd")
	    trial_user.each do |sub|
	      logger.debug("paying for user #{sub.id}")
	      User.create_charge(sub)
	    end
	  end
	end

end
