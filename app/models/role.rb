class Role < ActiveRecord::Base
  belongs_to :user
  attr_accessible :role_type
end
