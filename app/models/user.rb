class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses
  has_one  :subscription
  accepts_nested_attributes_for :addresses, :subscription
  attr_accessible :email, :name, :password, :remember_me, :addresses_attributes, :subscription_attributes

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body
end
