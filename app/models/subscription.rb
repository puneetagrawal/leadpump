class Subscription < ActiveRecord::Base
  attr_accessible :stripe_card_token, :customer_id, :charge_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count, :plan_type
  belongs_to :plan_per_user_range
  belongs_to :user
  
  #attr_accessor :stripe_card_token, :customer_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count

  def self.saveSubscription(user)
	user.subscription.plan_per_user_range_id = @planPerUser.id
	user.subscription.customer_id = charge.id
	user.subscription.stripe_card_token = params["user"]["subscription_attributes"]["stripe_card_token"]
	resource.expiry_date = DateTime.strptime("2013-12-30 11:59:59", '%Y-%m-%d %I:%M:%p')
	resource.subscription.save  
  end

end