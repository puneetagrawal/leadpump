class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessible :email, :name, :password, :remember_me, :addresses_attributes, :subscriptions_attributes
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses
  has_many :subscriptions
  accepts_nested_attributes_for :addresses, :subscriptions

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body
end
