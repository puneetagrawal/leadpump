class Plan < ActiveRecord::Base
  has_many :subscriptions

  attr_accessible :name, :price
end