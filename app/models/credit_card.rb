class CreditCard < ActiveRecord::Base
  attr_accessible :customer_id, :user_id

  belongs_to :user
end
