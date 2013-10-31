class Role < ActiveRecord::Base
  has_one :user
  attr_accessible :role_type
end
