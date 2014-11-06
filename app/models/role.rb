class Role < ActiveRecord::Base
	attr_accessible :role_type	
  has_one :user

end
