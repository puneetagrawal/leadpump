class Subscription < ActiveRecord::Base
  attr_accessible :stripe_card_token, :customer_id, :charge_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count, :plan_type, :expiry_date
  belongs_to :plan_per_user_range
  belongs_to :user
  
  #attr_accessor :stripe_card_token, :customer_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count

  def self.saveSubscription(user, planperuser, stripecarttoken, datetime, payment, no_of_users, no_of_locations, planType, customerid, chargeid)
    logger.debug("subscription")
  	if user.subscription.nil?
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
      sub = Subscription.new(:user_id=>user.id,:plan_per_user_range_id=>planperuser,:stripe_card_token=>
        stripecarttoken,:expiry_date=>datetime,:payment=>payment,:users_count=>no_of_users,
        :locations_count=>no_of_locations,:plan_type=>planType,:customer_id=>customerid,:charge_id=>chargeid)
      if sub.save
        logger.debug("subacript saved")
        user.save
      else
        logger.debug(sub.errors.full_messages)
      end
    else
      logger.debug("else part")
      user.subscription.plan_per_user_range_id = planperuser
      user.subscription.stripe_card_token = stripecarttoken
      user.subscription.expiry_date = datetime
      user.subscription.payment = payment
      user.subscription.users_count = no_of_users
      user.subscription.locations_count = no_of_locations
      user.subscription.plan_type = planType
      user.subscription.customer_id = customerid
      user.subscription.charge_id = chargeid
      if user.subscription.save
        logger.debug("saved subscription")
      else
        logger.debug(user.subscription.errors.full_messages)
      end
      
    end
      logger.debug("complete")
  end

  def self.upgrade_user_plan(user, planperuserId,users,
    locations,customerId, stripe_token)
    sub = Subscription.where(:user_id=>2).last
    if sub.present?
      plan = PlanPerUserRange.where(:id=>planperuserId).last
      payment = Subscription.get_payment(plan, users)
      sub.plan_per_user_range_id = planperuserId
      sub.customer_id = customerId
      sub.payment = payment
      sub.expiry_date = Date.today + 365
      sub.plan_type = "yearly"
      sub.stripe_card_token = stripe_token
      sub.users_count = users
      if sub.save
        user.users_created = 0
        user.leads_created = 0
        user.save
      end
    end
  end

  def self.get_payment(plan, users)
    return plan.price * users.to_i
  end
  
end