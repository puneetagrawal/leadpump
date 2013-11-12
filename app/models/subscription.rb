class Subscription < ActiveRecord::Base
  attr_accessible :stripe_card_token, :customer_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count
  belongs_to :plan_per_user_range
  belongs_to :user
  
  attr_accessor :stripe_card_token, :customer_id, :payment, :plan_per_user_range_id, :user_id, :users_count, :locations_count

end