class Subscription < ActiveRecord::Base
  attr_accessible :plan_id, :stripe_card_token
  belongs_to :plan
  belongs_to :user
  validates_presence_of :plan_id
  before_save  :save_with_payment
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      # customer = Stripe::Customer.create(plan: plan_id, card: stripe_card_token)
      # self.stripe_card_token = customer.id
      # save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end