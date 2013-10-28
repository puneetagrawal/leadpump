class Subscription < ActiveRecord::Base
  attr_accessible :plan_id, :stripe_card_token
  belongs_to :plan
  belongs_to :user
  validates_presence_of :plan_id
  
  attr_accessor :stripe_card_token
  
  

end