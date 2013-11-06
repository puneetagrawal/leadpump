class PlanPerUserRange < ActiveRecord::Base
  attr_accessible :plan_id, :price, :user_range_id
  belongs_to :user_range
  belongs_to :plan
  has_many :subscriptions
end
