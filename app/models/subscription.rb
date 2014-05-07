class Subscription < ActiveRecord::Base
  attr_accessible :stripe_card_token, :customer_id, :charge_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count, :plan_type, :expiry_date
  belongs_to :plan_per_user_range
  belongs_to :user
  
  #attr_accessor :stripe_card_token, :customer_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count

  def self.saveSubscription(user, planperuser, stripecarttoken, datetime, payment, no_of_users, no_of_locations, planType, customerid, chargeid)
  	if user.subscription.nil?
      sub = Subscription.new(:user_id=>user.id,:plan_per_user_range_id=>planperuser,:stripe_card_token=>
        stripecarttoken,:expiry_date=>datetime,:payment=>payment,:users_count=>no_of_users,
        :locations_count=>no_of_locations,:plan_type=>planType,:customer_id=>customerid,:charge_id=>chargeid)
      if sub.save
        user.subscription_id = sub
        user.save
      else
        logger.debug(sub.errors.full_messages)
      end
    else
      user.subscription.plan_per_user_range_id = planperuser
      user.subscription.stripe_card_token = stripecarttoken
      user.subscription.expiry_date = datetime
      user.subscription.payment = payment
      user.subscription.users_count = no_of_users
      user.subscription.locations_count = no_of_locations
      user.subscription.plan_type = planType
      user.subscription.customer_id = customerid
      user.subscription.charge_id = chargeid
      user.subscription.save
    end
  end

end